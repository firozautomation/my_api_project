package linking;

import com.intuit.karate.junit4.Karate;
import cucumber.api.CucumberOptions;
import org.junit.runner.RunWith;

@RunWith(Karate.class)
@CucumberOptions(features = "src/test/java/linking/http_404_responses.feature", tags= {"~@wip"}, format = {"pretty", "html:reports"})
public class Http401ResponsesTest {

}