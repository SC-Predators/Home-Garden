package com.drimaes.homegardenserver.user;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import com.drimaes.homegardenserver.config.BaseException;
import com.drimaes.homegardenserver.config.BaseResponse;
import com.drimaes.homegardenserver.user.model.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;


import java.util.List;

import static com.drimaes.homegardenserver.config.BaseResponseStatus.*;

@RestController // Rest API 또는 WebAPI를 개발하기 위한 어노테이션. @Controller + @ResponseBody 를 합친것.
// @Controller      [Presentation Layer에서 Contoller를 명시하기 위해 사용]
//  [Presentation Layer?] 클라이언트와 최초로 만나는 곳으로 데이터 입출력이 발생하는 곳
//  Web MVC 코드에 사용되는 어노테이션. @RequestMapping 어노테이션을 해당 어노테이션 밑에서만 사용할 수 있다.
// @ResponseBody    모든 method의 return object를 적절한 형태로 변환 후, HTTP Response Body에 담아 반환.
@RequestMapping("/app/users")
// method가 어떤 HTTP 요청을 처리할 것인가를 작성한다.
// 요청에 대해 어떤 Controller, 어떤 메소드가 처리할지를 맵핑하기 위한 어노테이션
// URL(/app/users)을 컨트롤러의 메서드와 매핑할 때 사용
/**
 * Controller란?
 * 사용자의 Request를 전달받아 요청의 처리를 담당하는 Service, Prodiver 를 호출
 */
public class userController {
    // *********************** 동작에 있어 필요한 요소들을 불러옵니다. *************************

    final Logger logger = LoggerFactory.getLogger(this.getClass()); // Log를 남기기: 일단은 모르고 넘어가셔도 무방합니다.

    @Autowired  // 객체 생성을 스프링에서 자동으로 생성해주는 역할. 주입하려 하는 객체의 타입이 일치하는 객체를 자동으로 주입한다.
    // IoC(Inversion of Control, 제어의 역전) / DI(Dependency Injection, 의존관계 주입)에 대한 공부하시면, 더 깊이 있게 Spring에 대한 공부를 하실 수 있을 겁니다!(일단은 모르고 넘어가셔도 무방합니다.)
    // IoC 간단설명,  메소드나 객체의 호출작업을 개발자가 결정하는 것이 아니라, 외부에서 결정되는 것을 의미
    // DI 간단설명, 객체를 직접 생성하는 게 아니라 외부에서 생성한 후 주입 시켜주는 방식
    private userProvider userProvider;
    @Autowired
    private userService userService;

    public userController(userProvider userProvider, userService userService) {
        this.userProvider = userProvider;
        this.userService = userService;
    }

    // ******************************************************************************

    /**
     * 회원가입 API
     * [POST] /users
     */
    // Body
    @ResponseBody
    @PostMapping("/sign-up")    // POST 방식의 요청을 매핑하기 위한 어노테이션
    public BaseResponse<String> createUser(@RequestBody PostUserReq postUserReq) {
        //  @RequestBody란, 클라이언트가 전송하는 HTTP Request Body(우리는 JSON으로 통신하니, 이 경우 body는 JSON)를 자바 객체로 매핑시켜주는 어노테이션
        // email에 값이 존재하는지, 빈 값으로 요청하지는 않았는지 검사합니다. 빈값으로 요청했다면 에러 메시지를 보냅니다.
        if (postUserReq.getClientID() == null) {
            return new BaseResponse<>(POST_USERS_EMPTY_CLIENTID);
        }
        if (postUserReq.getPassword() == null) {
            return new BaseResponse<>(POST_USERS_EMPTY_PASSWORD);
        }

        try {
            String postUserRes = userService.createUser(postUserReq);
            return new BaseResponse<>(postUserRes);
        } catch (BaseException exception) {
            return new BaseResponse<>((exception.getStatus()));
        }
    }
    /**
     * 회원 삭제 API
     * [Delete] app/users/sign-up
     */
    @ResponseBody
    @DeleteMapping("sign-up")
    public BaseResponse<String> deleteUser(@RequestBody GetUserReq getUserReq){
        try {
            String result = userService.deleteUser(getUserReq);
            return new BaseResponse<>(result);
        }catch (BaseException exception){
            return new BaseResponse<>((exception.getStatus()));
        }
    }

    /**
     * 가입자의 중복 ID입력 확인!
     * [Post] app/users/sign-up
     * **/
    @ResponseBody
    @PostMapping("/sign-up/checkID")
    public BaseResponse<String> isDuplicatedUser(@RequestBody GetIsDuplicatedUserReq getIsDuplicatedUserReq) {
        if (getIsDuplicatedUserReq.getClientID() == null) {
            return new BaseResponse<>(POST_USERS_EMPTY_CLIENTID);
        }
        try {
            String isDuplicatedResult = userProvider.isDuplicatedUser(getIsDuplicatedUserReq);
            return new BaseResponse<>(isDuplicatedResult);
        } catch (BaseException exception) {
            return new BaseResponse<>((exception.getStatus()));
        }
    }
    /**
     * 식물 닉네임 받아오기.
     * [get] app/users/plant/nickname
     */
    @ResponseBody
    @PostMapping("/plant/nickname")
    public BaseResponse<GetUserPlantNickNameRes> getUserPlantNickNameWithCLIENTID(@RequestBody GetUserReq getUserReq){
        if(getUserReq.getClientID() == null){
            return new BaseResponse<>(USERS_EMPTY_USER_ID);
        }
        try{
            GetUserPlantNickNameRes getUserPlantNickNameRes = userProvider.getUserPlantNickName(getUserReq);
            return new BaseResponse<>(getUserPlantNickNameRes);
        } catch (BaseException exception) {
            return new BaseResponse<>((exception.getStatus()));
        }
    }

    @ResponseBody
    @PostMapping("/log-in")
    public BaseResponse<PostLoginRes> logIn(@RequestBody PostLoginReq postLoginReq) {
        try {
            if (postLoginReq.getClientID() == null) {// 이메일이 NULL값인지 확인
                return new BaseResponse<>(FAILED_TO_LOGIN_CAUSED_BY_EMAIL);
            }
            PostLoginRes postLoginRes = userProvider.logIn(postLoginReq);
            if(postLoginRes.getUserStatus().equals("A"))return new BaseResponse<>(postLoginRes);
            else  return new BaseResponse<>(USERS_SATUS_NOT_ACTIVATED);
        } catch (BaseException exception) {
            return new BaseResponse<>(exception.getStatus());
        }
    }

    /**
     * 식물 현재 상태 받아오기.
     * [get] http://localhost:23628/app/users/plant/present
     */
    @ResponseBody
    @PostMapping("plant/present")
    public BaseResponse<GetPlantStatusRes> getPresentPlantStatus(@RequestBody GetPresentPlantStatusReq getPresentPlantStatusReq){
        if(getPresentPlantStatusReq.getClientID() == null){
            return new BaseResponse<>(USERS_EMPTY_USER_ID);
        }
        try{
            GetPlantStatusRes getPlantStatusRes = userProvider.getPresentPlantStatus(getPresentPlantStatusReq);
            return new BaseResponse<>(getPlantStatusRes);
        } catch (BaseException exception){
            return new BaseResponse<>((exception.getStatus()));
        }
    }

    /**
     * 식물 과거 상태 받아오기.
     * [get] http://localhost:23628/app/users/plant/history
     */
    @ResponseBody
    @PostMapping("plant/history")
    public BaseResponse<GetPlantStatusRes> getHistoryPlantStatus(@RequestBody GetHistoryPlantStatusReq getHistoryPlantStatusReq){
        if(getHistoryPlantStatusReq.getClientID()==null){
            return new BaseResponse<>(USERS_EMPTY_USER_ID);
        }
        try{
            GetPlantStatusRes getPlantStatusRes = userProvider.getHistoryPlantStatus(getHistoryPlantStatusReq);
            return new BaseResponse<>(getPlantStatusRes);
        }catch (BaseException exception){
            return new BaseResponse<>((exception.getStatus()));
        }
    }

    /**
     * 식물 모드 가져오기
     * [post] http://218.152.140.80:23628/app/users/plant/mode
     */
    @ResponseBody
    @PostMapping("plant/mode")
    public BaseResponse<PostUserModeRes> postPlantMode(@RequestBody GetUserReq getUserReq){
        if(getUserReq.getClientID() == null){
            return new BaseResponse<>(USERS_EMPTY_USER_ID);
        }
        try{
            PostUserModeRes postUserModeRes = userProvider.postPlantMode(getUserReq);
            System.out.println(postUserModeRes);
            return new BaseResponse<>(postUserModeRes);
        }catch (BaseException exception){
            return new BaseResponse<>((exception.getStatus()));
        }
    }

    /**
     * 식물 모드 변경하기
     * [patch] http://218.152.140.80:23628/app/users/plant/mode
     */
    @ResponseBody
    @PatchMapping("plant/mode")
    public BaseResponse<String> patchPlantMode(@RequestBody PatchModeReq patchModeReq){
        if(patchModeReq.getClientID()==null){
            return new BaseResponse<>(USERS_EMPTY_USER_ID);
        }
        try{
            String postModRes = userService.patchPlantMode(patchModeReq);
            return new BaseResponse<>(postModRes);
        }catch (BaseException exception){
            return new BaseResponse<>((exception.getStatus()));
        }
    }

    /**
     * 식물 수동 모드 변경하기
     * [post] http://218.152.140.80:23628/app/users/plant/active
     */
    @ResponseBody
    @PostMapping("plant/active")
    public BaseResponse<String> postManualPlantMode(@RequestBody PostManualStateReq postManualStateReq){
        try{
            String postManualModeRes = userService.postManualPlantMode(postManualStateReq);
            return new BaseResponse<>(postManualModeRes);
        }catch (BaseException exception){
            return new BaseResponse<>((exception.getStatus()));
        }
    }




}
