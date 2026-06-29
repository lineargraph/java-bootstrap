// Tiny assertion helper shared by all probes.
// Java 1.4 clean (no generics / foreach / autoboxing) so jikes -source 1.4 is happy.
public class Check {
    public static boolean failed = false;

    public static void that(String label, boolean cond) {
        System.out.println((cond ? "  ok  " : "  BAD ") + label);
        if (!cond) failed = true;
    }

    // Print the machine-readable verdict the runner greps for, and exit
    // with a matching code so a crash vs. a clean fail are distinguishable.
    public static void done(String name) {
        System.out.println((failed ? "FAIL: " : "PASS: ") + name);
        System.out.flush();
        System.exit(failed ? 1 : 0);
    }
}
