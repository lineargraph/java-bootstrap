import java.util.regex.Matcher;
import java.util.regex.Pattern;

// Classpath 0.93's java.util.regex returned wrong answers (RegexTest printed
// false for a string that must match).
// At least these basic matches should work.
public class RegexTest {
    public static void main(String[] a) {
        Check.that("'abc' matches 'a.c'",   "abc".matches("a.c"));
        Check.that("'/' matches '[/\\\\]'", "/".matches("[/\\\\]"));

        Matcher m = Pattern.compile("^(.*)[/\\\\]pom\\.xml")
                           .matcher("etc/poms/x/pom.xml");
        boolean matched = m.matches();
        Check.that("pom pattern matches", matched);
        if (matched) {
            Check.that("group(1) == 'etc/poms/x'", "etc/poms/x".equals(m.group(1)));
        }
        Check.done("RegexTest");
    }
}
