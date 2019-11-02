package rest;


import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.MediaType;
import org.springframework.test.context.junit4.SpringRunner;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders;

import static org.hamcrest.Matchers.equalTo;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.content;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@RunWith(SpringRunner.class)
@SpringBootTest
@AutoConfigureMockMvc
public class NumSequenceControllerTest {

    @Autowired
    private MockMvc mvc;

    @Test
    public void testRESTApi() throws Exception{
        mvc.perform(MockMvcRequestBuilders.get("/").accept(MediaType.APPLICATION_JSON)).
                andExpect(status().isOk()).
                andExpect(content().string(equalTo(NumSequenceController.WELCOME_MESSAGE)));
    }

    @Test
    public void testNumSeq() throws Exception{
        mvc.perform(MockMvcRequestBuilders.get("/seq?index=0").accept(MediaType.APPLICATION_JSON)).
                andExpect(status().isOk()).
                andExpect(content().string(equalTo("0")));

        mvc.perform(MockMvcRequestBuilders.get("/seq?index=1").accept(MediaType.APPLICATION_JSON)).
                andExpect(status().isOk()).
                andExpect(content().string(equalTo("1")));
    }
}
