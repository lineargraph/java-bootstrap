import java.io.BufferedReader;
import java.io.InputStreamReader;

public class ExecTest {
    public static void main(String[] a) throws Exception {
        Process p = Runtime.getRuntime().exec(new String[]{ "hello", "-g", "marker123" });


        BufferedReader r = new BufferedReader(new InputStreamReader(p.getInputStream()));
        StringBuffer sb = new StringBuffer();
        String line;
        while ((line = r.readLine()) != null) sb.append(line);
        int code = p.waitFor();

        Check.that("child stdout contains marker", sb.toString().indexOf("marker123") >= 0);
        Check.eq("exit code", 0, code);
        Check.done("ExecTest");
    }
}
