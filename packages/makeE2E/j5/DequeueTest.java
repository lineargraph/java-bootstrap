package j5;

import util.*;

import java.util.*;

public class DequeueTest {
    public static void main(String[] args) {
        Deque<String> queue = new ArrayDeque<String>();
        Check.that("queue.isEmpty()", queue.isEmpty());
        queue.addFirst("world");
        queue.addLast("goodbye");
        queue.addLast("world");
        queue.addFirst("hello");

        boolean first = true;
        for (String string : queue) {
            if (first) Check.eq("first()", "hello", string);
        }
    }
}
