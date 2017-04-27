package linking;

import com.intuit.karate.junit4.Karate;
import cucumber.api.CucumberOptions;
import org.junit.runner.RunWith;

@RunWith(Karate.class)
@CucumberOptions(features =
        {"src/test/java/linking/invalid_authorization_exceptions.feature",
        "src/test/java/linking/invalid_direction_id_exceptions.feature",
        "src/test/java/linking/invalid_document_or_project_id_exceptions.feature"},
        format = {"pretty", "html:reports"},
        tags = {"@run"})
public class Http_401_404_400_ResponsesTest {

}