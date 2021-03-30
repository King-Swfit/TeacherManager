package com.haitong.youcai.config;

import com.haitong.youcai.entity.SysLog;
import com.haitong.youcai.service.SysLogService;
import com.haitong.youcai.utils.IpAdrressUtil;
import com.haitong.youcai.utils.JacksonUtil;
import com.haitong.youcai.utils.Tool;
import com.sun.org.apache.xpath.internal.operations.Operation;
import org.aspectj.lang.JoinPoint;
import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.*;
import org.aspectj.lang.reflect.MethodSignature;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.AnonymousAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Component;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import javax.servlet.http.HttpServletRequest;
import java.lang.reflect.Method;
import java.util.Arrays;
import java.util.Date;

@Aspect
@Component
public class LogAspect  {
    @Autowired
    private SysLogService sysLogService;

    @Pointcut("execution(public * com.haitong.youcai.controller.*.*(..))")
    public void LogAspect(){}

//    @Before("LogAspect()")
//    public void doBefore(JoinPoint joinPoint){
//        System.out.println("doBefore");
//    }

    @After("LogAspect()")
    public void doAfter(JoinPoint joinPoint){
        //保存日志
        SysLog sysLog = new SysLog();
        //获取用户名
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (!(authentication instanceof AnonymousAuthenticationToken)) {
            sysLog.setUsername(authentication.getName());
        }

        //获取用户ip地址
        HttpServletRequest request = ((ServletRequestAttributes) RequestContextHolder.getRequestAttributes())
                .getRequest();
        sysLog.setIp(IpAdrressUtil.getIpAdrress(request));


        String method = joinPoint.getSignature().toString();

        sysLog.setMethod(method);

        //请求的参数
        Object[] args = joinPoint.getArgs();

        //String params = "{action:暂时不取,reason:取值时出错}";
        //将参数所在的数组转换成json
        String params = null;
        try {
            System.out.println(args.toString());
            params = JacksonUtil.obj2json(args);

            if(params.length() > 100){
                params = params.substring(0, 100);
            }
        } catch (Exception e) {
            e.printStackTrace();
            params = "";
        }

        sysLog.setParams(params);


        //请求的时间
        sysLog.setCreateDate(Tool.getCurrentDetailDate());

        System.out.println(sysLog.toString());

        //调用service保存SysLog实体类到数据库
        sysLogService.saveLog(sysLog);

    }

//    @AfterReturning("LogAspect()")
//    public void doAfterReturning(JoinPoint joinPoint){
//        System.out.println("doAfterReturning");
//    }
//
//    @AfterThrowing("LogAspect()")
//    public void deAfterThrowing(JoinPoint joinPoint){
//        System.out.println("deAfterThrowing");
//    }
//
//    @Around("LogAspect()")
//    public Object deAround(ProceedingJoinPoint joinPoint) throws Throwable{
//        System.out.println("deAround");
//        return joinPoint.proceed();
//    }


}