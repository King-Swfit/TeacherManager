package com.haitong.youcai.controller;

import com.haitong.youcai.utils.Tool;

/**
 * Created by Administrator on 2019/6/25.
 */
public class Test {
    public static void main(String[] args) {
        String str = "pj1903";
        String str1 = str.substring(str.length() - 2);
        System.out.println(str1);

        String str2 = str.substring(str.length() - 4, str.length() - 2);
        System.out.println(str2);

        String [] section = Tool.getDefaultTimeSection();
        System.out.println(section[0] + ":" + section[1]);
    }
}
