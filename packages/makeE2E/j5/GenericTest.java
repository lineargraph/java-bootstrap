package j5;

import util.*;

public class GenericTest {
    public static <T> T id(T t) {
        return t;
    }

    public static void main(String[] a) throws Exception {
        Check.eq("id(hello)", "hello", id("hello"));
        Check.done("GenericTest");
    }
}
