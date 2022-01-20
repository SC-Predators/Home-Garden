package com.drimaes.homegardenserver.user;

import com.drimaes.homegardenserver.user.model.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

import javax.sql.DataSource;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.List;
import java.util.Locale;

@Repository //  [Persistence Layer에서 DAO를 명시하기 위해 사용]

/**
 * DAO란?
 * 데이터베이스 관련 작업을 전담하는 클래스
 * 데이터베이스에 연결하여, 입력 , 수정, 삭제, 조회 등의 작업을 수행
 */
public class userDAO {

    // *********************** 동작에 있어 필요한 요소들을 불러옵니다. *************************

    private JdbcTemplate jdbcTemplate;

    @Autowired //readme 참고
    public void setDataSource(DataSource dataSource) {
        this.jdbcTemplate = new JdbcTemplate(dataSource);
    }
    // ******************************************************************************

    /**
     * DAO관련 함수코드의 전반부는 크게 String ~~~Query와 Object[] ~~~~Params, jdbcTemplate함수로 구성되어 있습니다.(보통은 동적 쿼리문이지만, 동적쿼리가 아닐 경우, Params부분은 없어도 됩니다.)
     * Query부분은 DB에 SQL요청을 할 쿼리문을 의미하는데, 대부분의 경우 동적 쿼리(실행할 때 값이 주입되어야 하는 쿼리) 형태입니다.
     * 그래서 Query의 동적 쿼리에 입력되어야 할 값들이 필요한데 그것이 Params부분입니다.
     * Params부분은 클라이언트의 요청에서 제공하는 정보(~~~~Req.java에 있는 정보)로 부터 getXXX를 통해 값을 가져옵니다. ex) getEmail -> email값을 가져옵니다.
     *      Notice! get과 get의 대상은 카멜케이스로 작성됩니다. ex) item -> getItem, password -> getPassword, email -> getEmail, userIdx -> getUserIdx
     * 그 다음 GET, POST, PATCH 메소드에 따라 jabcTemplate의 적절한 함수(queryForObject, query, update)를 실행시킵니다(DB요청이 일어납니다.).
     *      Notice!
     *      POST, PATCH의 경우 jdbcTemplate.update
     *      GET은 대상이 하나일 경우 jdbcTemplate.queryForObject, 대상이 복수일 경우, jdbcTemplate.query 함수를 사용합니다.
     * jdbcTeplate이 실행시킬 때 Query 부분과 Params 부분은 대응(값을 주입)시켜서 DB에 요청합니다.
     * <p>
     * 정리하자면 < 동적 쿼리문 설정(Query) -> 주입될 값 설정(Params) -> jdbcTemplate함수(Query, Params)를 통해 Query, Params를 대응시켜 DB에 요청 > 입니다.
     * <p>
     * <p>
     * DAO관련 함수코드의 후반부는 전반부 코드를 실행시킨 후 어떤 결과값을 반환(return)할 것인지를 결정합니다.
     * 어떠한 값을 반환할 것인지 정의한 후, return문에 전달하면 됩니다.
     * ex) return this.jdbcTemplate.query( ~~~~ ) -> ~~~~쿼리문을 통해 얻은 결과를 반환합니다.
     */

    /**
     * 참고 링크
     * https://jaehoney.tistory.com/34 -> JdbcTemplate 관련 함수에 대한 설명
     * https://velog.io/@seculoper235/RowMapper%EC%97%90-%EB%8C%80%ED%95%B4 -> RowMapper에 대한 설명
     */

    // 회원가입
    public String createUser(PostUserReq postUserReq) {
        String createUserQuery = "insert into Homegarden_Client (homegardenID,clientID, clientPW, plantNickName, mode) VALUES (?,?,?,?,?)"; // 실행될 동적 쿼리문
        Object[] createUserParams = new Object[]{postUserReq.getHomegarden_barcode(),postUserReq.getClientID(), postUserReq.getPassword(), postUserReq.getPlantNickName(), postUserReq.getMode()}; // 동적 쿼리의 ?부분에 주입될 값
        String insertDesiredStateQuery = "INSERT INTO Desired_state(homegardenID, clientID, desired_light, desired_humidity) VALUES (?, ?, ?, ?);";
        String presentSetupQuery = "INSERT INTO Present_state (homegardenID, humidity, light, water_level, phStatus, img) VALUES (?, 0, 0, 0, 0, 0)";
        this.jdbcTemplate.update(createUserQuery, createUserParams);
        System.out.println("=====================");
        System.out.println("사용자 회원가입");
        System.out.println("사용자 ID: " + postUserReq.getClientID() + " 사용자 모드: "+postUserReq.getMode());
        System.out.println("원하는 습도: " + postUserReq.getDesired_humidity() + " 원하는 조도: " + postUserReq.getDesired_illuminance());
        System.out.println("=====================");

        if(postUserReq.getMode().equals("M"))
        {
            Object[] insertDesiredStateParams = new Object[]{postUserReq.getHomegarden_barcode(), postUserReq.getClientID(), postUserReq.getDesired_illuminance(), postUserReq.getDesired_humidity()};
            this.jdbcTemplate.update(insertDesiredStateQuery, insertDesiredStateParams);
            System.out.println("Manual mode");
        }
        else if(postUserReq.getMode().equals("A"))
        {
            Object[] insertDesiredStateParams = new Object[]{postUserReq.getHomegarden_barcode(), postUserReq.getClientID(), 200, 50};
            this.jdbcTemplate.update(insertDesiredStateQuery, insertDesiredStateParams);
            System.out.println("Auto mode");
        }
        this.jdbcTemplate.update(presentSetupQuery, postUserReq.getHomegarden_barcode());
        System.out.println("Done");

        return "가입 : "+postUserReq.getClientID();
    }

    //사용자 삭제
    public int deleteUser(GetUserReq getUserReq){
        String deleteUserQuery1 = "Delete from Desired_state where clientID = ?";
        String deleteUserQuery2 = "Delete from Present_state where homegardenID = ?";
        String getHomegardenId = "SELECT HC.homegardenID from Homegarden_Client HC, Present_state PS WHERE HC.homegardenID = PS.homegardenID AND HC.clientID = ?";
        String deleteUserQuery3 = "Delete from Homegarden_Client where clientID = ?";
        String clientID = getUserReq.getClientID();



        this.jdbcTemplate.update(deleteUserQuery1, clientID);
        String homegardenId = this.jdbcTemplate.queryForObject(getHomegardenId, String.class, clientID);
        System.out.println("=====================");
        System.out.println("사용자 정보삭제");
        System.out.println("ClientID: " + clientID);
        System.out.println("=====================");
        this.jdbcTemplate.update(deleteUserQuery2, homegardenId);

        return this.jdbcTemplate.update(deleteUserQuery3, clientID);
    }

    //식물 닉네임 확인
    public GetUserPlantNickNameRes getClienPlantNickName(GetUserReq getUserReq){
        String getUserQuery = "SELECT plantNickName FROM Homegarden_Client WHERE clientID = ?";
        String getClientID = getUserReq.getClientID();

        return this.jdbcTemplate.queryForObject(getUserQuery,
                (rs, rowNum) -> new GetUserPlantNickNameRes(
                        rs.getString("plantNickName")
                ), // RowMapper(위의 링크 참조): 원하는 결과값 형태로 받기
                getClientID
        );
    }
    //아이디 중복 확인
    public int getIsDuplicatedUser(GetIsDuplicatedUserReq getIsDuplicatedUserReq){
        String getUserQuery = "SELECT COUNT(ClientID) FROM Homegarden_Client WHERE clientID= ?";
        String getClientID = getIsDuplicatedUserReq.getClientID();

        int result = this.jdbcTemplate.queryForObject(getUserQuery, int.class, getClientID);
        System.out.println(result);

        return result;
    }

    // 이메일 확인
    public int checkEmail(String email) {
        String checkEmailQuery = "select exists(select email from User where email = ?)"; // User Table에 해당 email 값을 갖는 유저 정보가 존재하는가?
        String checkEmailParams = email; // 해당(확인할) 이메일 값
        return this.jdbcTemplate.queryForObject(checkEmailQuery,
                int.class,
                checkEmailParams); // checkEmailQuery, checkEmailParams를 통해 가져온 값(intgud)을 반환한다. -> 쿼리문의 결과(존재하지 않음(False,0),존재함(True, 1))를 int형(0,1)으로 반환됩니다.
    }

    // 회원정보 변경
    public int modifyUserName(PatchUserReq patchUserReq) {
        String modifyUserNameQuery = "update User set nickname = ? where userIdx = ? "; // 해당 userIdx를 만족하는 User를 해당 nickname으로 변경한다.
        Object[] modifyUserNameParams = new Object[]{patchUserReq.getNickname(), patchUserReq.getUserIdx()}; // 주입될 값들(nickname, userIdx) 순

        return this.jdbcTemplate.update(modifyUserNameQuery, modifyUserNameParams); // 대응시켜 매핑시켜 쿼리 요청(생성했으면 1, 실패했으면 0)
    }


    // 로그인: 해당 clientID에 해당되는 user의 암호화된 비밀번호 값을 가져온다.
    public User getPwd(PostLoginReq postLoginReq) {
        String getPwdQuery = "select * from Homegarden_Client where clientID = ?";
        String getPwdParams = postLoginReq.getClientID();

        return this.jdbcTemplate.queryForObject(getPwdQuery,
                (rs, rowNum) -> new User(
                        rs.getString("homegardenID"),
                        rs.getString("plantNickName"),
                        rs.getString("clientPW"),
                        rs.getString("activeStatus")),
                getPwdParams
        );
    }

    // User 테이블에 존재하는 전체 유저들의 정보 조회
    public List<GetUserRes> getUsers() {
        String getUsersQuery = "select * from User";
        return this.jdbcTemplate.query(getUsersQuery,
                (rs, rowNum) -> new GetUserRes(
                        rs.getInt("userIdx"),
                        rs.getString("nickname"),
                        rs.getString("Email"),
                        rs.getString("password"))
        );
    }

    // 해당 nickname을 갖는 유저들의 정보 조회
    public List<GetUserRes> getUsersByNickname(String nickname) {
        String getUsersByNicknameQuery = "select * from User where nickname =?"; // 해당 이메일을 만족하는 유저를 조회하는 쿼리문
        String getUsersByNicknameParams = nickname;
        return this.jdbcTemplate.query(getUsersByNicknameQuery,
                (rs, rowNum) -> new GetUserRes(
                        rs.getInt("userIdx"),
                        rs.getString("nickname"),
                        rs.getString("Email"),
                        rs.getString("password")), // RowMapper(위의 링크 참조): 원하는 결과값 형태로 받기
                getUsersByNicknameParams); // 해당 닉네임을 갖는 모든 User 정보를 얻기 위해 jdbcTemplate 함수(Query, 객체 매핑 정보, Params)의 결과 반환
    }

    // 해당 userIdx를 갖는 유저조회
    public GetUserRes getUser(int userIdx) {
        String getUserQuery = "select * from User where userIdx = ?"; // 해당 userIdx를 만족하는 유저를 조회하는 쿼리문
        int getUserParams = userIdx;
        return this.jdbcTemplate.queryForObject(getUserQuery,
                (rs, rowNum) -> new GetUserRes(
                        rs.getInt("userIdx"),
                        rs.getString("nickname"),
                        rs.getString("Email"),
                        rs.getString("password")), // RowMapper(위의 링크 참조): 원하는 결과값 형태로 받기
                getUserParams); // 한 개의 회원정보를 얻기 위한 jdbcTemplate 함수(Query, 객체 매핑 정보, Params)의 결과 반환
    }

    // 해당 Email을 갖는 유저 삭제
    public int deleteUserByEmail(String userEmail){
        String deleteUserQueryByEamil = "delete from User where email =?"; //해당 이메일을 만족하는 유저를 조회하는 쿼리문
        String getUserByEmail = userEmail;
        return this.jdbcTemplate.update(deleteUserQueryByEamil, getUserByEmail);
    }

    //가장 최근의 식물 정보 반환
    public GetPlantStatusRes getPresentPlantStatus(GetPresentPlantStatusReq getPresentPlantStatusReq){
        String getPresentStateQuery = "SELECT  humidity, light, water_level, phStatus FROM Present_state PS, Homegarden_Client HC WHERE PS.homegardenID = HC.homegardenID AND HC.clientID= ? ORDER BY writeTime DESC LIMIT 1;";
        String getPresentImgQuery = "SELECT img FROM Present_state PS, Homegarden_Client HC WHERE img IS NOT NULL AND  PS.homegardenID = HC.homegardenID AND HC.clientID= ? ORDER BY  writeTime DESC LIMIT 1;";
        String clientID = getPresentPlantStatusReq.getClientID();
        String mostPresentImgURL = this.jdbcTemplate.queryForObject(getPresentImgQuery, String.class, clientID);

        return this.jdbcTemplate.queryForObject(getPresentStateQuery,
                (rs, rowNum) -> new GetPlantStatusRes(
                        "OK",
                        mostPresentImgURL,
                        rs.getInt("humidity"),
                        rs.getInt("light"),
                        rs.getInt("water_level"),
                        rs.getInt("phStatus")),
                clientID); // 한 개의 회원정보를 얻기 위한 jdbcTemplate 함수(Query, 객체 매핑 정보, Params)의 결과 반환
    }


    //시간이 주어졌을 때 식물 정보 반환
    public GetPlantStatusRes getHistoryPlantStatus(GetHistoryPlantStatusReq getHistoryPlantStatusReq){
        List<GetPlantStatusRes> resultList;
        //historyTime 에시: '2022-01-04 05:30:03';
        String historyTime = "2022-" + getHistoryPlantStatusReq.getMonth() + "-" + getHistoryPlantStatusReq.getDate() +" "+getHistoryPlantStatusReq.getHour()+":"+getHistoryPlantStatusReq.getMinute()+":00";
        String clientID = getHistoryPlantStatusReq.getClientID();
        String checkQuery = String.format("SELECT COUNT(*) FROM Present_state PS, Homegarden_Client HC " +
                                          "WHERE PS.homegardenID=HC.homegardenID AND HC.clientID = \"%s\" AND writeTime < \'%s\';", clientID, historyTime);
        if(this.jdbcTemplate.queryForObject(checkQuery, int.class)==0)
        {
            return new GetPlantStatusRes("이전 기록이 없습니다.", "0", 0, 0, 0, 0);
        }

        String makeHistoryView = String.format("CREATE VIEW HistoryVIEW AS " +
                                               "SELECT writeTime, temperature, humidity, light, water_level, phStatus, img " +
                                               "FROM Present_state PS, Homegarden_Client HC " +
                                               "WHERE PS.homegardenID = HC.homegardenID AND HC.clientID= \"%s\" AND writeTime < \'%s\'", clientID, historyTime);

        String getStateQuery = "SELECT  temperature, humidity, light, water_level, phStatus FROM HistoryVIEW ORDER BY writeTime DESC LIMIT 1;";
        String getImgQuery = "SELECT img FROM HOMEGARDEN.HistoryVIEW WHERE img IS NOT NULL ORDER BY  writeTime DESC LIMIT 1;";
        String dropViewQuery = "DROP VIEW HistoryVIEW;";

        System.out.println("=====================");
        System.out.println("히스토리 보기");
        System.out.println("ClientID: " + clientID);
        System.out.printf("[Month: %s, Date: %s, Hour: %s, Minute: %s]",

                            getHistoryPlantStatusReq.getMonth(), getHistoryPlantStatusReq.getDate(),getHistoryPlantStatusReq.getHour(), getHistoryPlantStatusReq.getMinute());
        System.out.println("\n=====================");
        //System.out.println(makeHistoryView);
        this.jdbcTemplate.execute(makeHistoryView);


        String mostPresentImgURL = this.jdbcTemplate.queryForObject(getImgQuery, String.class);

        //System.out.println(mostPresentImgURL);

        GetPlantStatusRes getPlantStatusRes = this.jdbcTemplate.queryForObject(getStateQuery,
                (rs, rowNum) -> new GetPlantStatusRes(
                        "OK",
                        mostPresentImgURL,
                        rs.getInt("humidity"),
                        rs.getInt("light"),
                        rs.getInt("water_level"),
                        rs.getInt("phStatus"))
                );

        this.jdbcTemplate.execute(dropViewQuery);
        return getPlantStatusRes;
    }

    //유저 모드 변경
    public int patchPlantMode(PatchModeReq patchModeReq){
        String updateModeQuery =  "UPDATE Homegarden_Client SET mode = ? WHERE clientID = ?";
        Object[] updateModeParams = new Object[]{patchModeReq.getMode(), patchModeReq.getClientID()};

        String updateDesiredStateQuery = "UPDATE Desired_state DS SET desired_light = ?, desired_humidity = ? WHERE  DS.clientID = ?;";
        Object[] updateDesiredStateParams = new Object[]{patchModeReq.getIlluminance(), patchModeReq.getHumidity(), patchModeReq.getClientID()};
        System.out.println("=====================");
        System.out.println("모드 업데이트");
        System.out.println("clientID: " + patchModeReq.getClientID() + " desired_Humidity: " + patchModeReq.getHumidity() + " desired_light: " + patchModeReq.getIlluminance());
        System.out.println("=====================");
        this.jdbcTemplate.update(updateModeQuery, updateModeParams);
        return this.jdbcTemplate.update(updateDesiredStateQuery, updateDesiredStateParams);
    }

    //유저 모드 가져오기
    public PostUserModeRes postPlantMode(GetUserReq getUserReq){
        //String.format("SELECT COUNT(*) FROM Present_state PS, Homegarden_Client HC " +
        //                                          "WHERE PS.homegardenID=HC.homegardenID AND HC.clientID = \"%s\" AND writeTime < \'%s\';", clientID, historyTime);
        String getModeQuery = "SELECT * FROM Desired_state DS, Homegarden_Client HC WHERE  HC.clientID = DS.clientID  AND DS.clientID = ?;";
        String clientID = getUserReq.getClientID();
        System.out.println("=====================");
        System.out.println("사용자 모드 가져오기");
        System.out.println("clientID: " + getUserReq.getClientID());
        System.out.println("=====================");
        return this.jdbcTemplate.queryForObject(getModeQuery,
                (rs, rowNum) -> new PostUserModeRes(
                        rs.getString("mode"),
                        rs.getInt("desired_light"),
                        rs.getInt("desired_humidity")),
                        clientID);
    }

}