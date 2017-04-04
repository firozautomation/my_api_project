/**
 * Created by satishautade on 01/04/17.
 */

import java.util.Base64;

public class BasicAuth {

    public static String encode(String toEncode){
        Base64.Encoder encoder = Base64.getEncoder();
        return encoder.encodeToString(toEncode.getBytes());

    }

}
