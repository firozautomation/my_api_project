package linking;

import com.intuit.karate.junit4.Karate;
import cucumber.api.CucumberOptions;
import org.junit.runner.RunWith;

@RunWith(Karate.class)
@CucumberOptions(features = "src/test/java/linking/invalid_direction_id_exceptions.feature", tags= {}, format = {"pretty", "html:reports"})
public class Http_401_404_400_ResponsesTest {

}