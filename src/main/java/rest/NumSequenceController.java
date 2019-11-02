package rest;

import math.NumSequence;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class NumSequenceController {

    public static final String WELCOME_MESSAGE = "Welcome to Dependency Management Section!";
    private static final String INVALID_NUMBER_INPUT = "Please input a valid number";

    @RequestMapping("/")
    public String index() {
        return WELCOME_MESSAGE + "@@@";
    }

    @RequestMapping(value = "/seq", params = {"index"})
    public @ResponseBody String sequence(@RequestParam(value = "index") String index){
        int idx = -1;
        try {
            idx = Integer.parseInt(index);
            if (idx < 0) {
                return INVALID_NUMBER_INPUT;
            }
        }catch (NumberFormatException e) {
            return INVALID_NUMBER_INPUT;
        }

        int res = NumSequence.mysteriousNumSeq(idx);

        return res+"";
    }
}