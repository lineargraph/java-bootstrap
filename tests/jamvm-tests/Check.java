// Tiny assertion helper shared by all probes.
// Java 1.4 clean (no generics / foreach / autoboxing) so jikes -source 1.4 is happy.
public class Check {
    public static boolean failed = false;

    public static void that(String label, boolean cond) {
        System.out.println((cond ? "  ok  " : "  BAD ") + label);
        if (!cond) failed = true;
    }

    public static void eq(String label, int expected, int actual) {
        eq(label, Integer.valueOf(expected), Integer.valueOf(actual));
    }

    public static void eq(String label, Object expected, Object actual) {
        that(label + " == " + expected + " (got " + actual + ")", expected == null ? actual == null : expected.equals(actual));
    }

    // Print the machine-readable verdict the runner greps for, and exit
    // with a matching code so a crash vs. a clean fail are distinguishable.
    public static void done(String name) {
        System.out.println((failed ? "FAIL: " : "PASS: ") + name);
        System.out.flush();
        System.exit(failed ? 1 : 0);
    }
}
