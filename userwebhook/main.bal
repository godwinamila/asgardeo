import ballerina/http;
import ballerina/log;

service /api on new http:Listener(8080) {

    // POST /api/submit
    resource function post submit(http:Caller caller, http:Request req) returns error? {
        json payload = check req.getJsonPayload();
        log:printInfo("Received payload: " + payload.toJsonString());

        http:Response res = new;
        res.setJsonPayload({ message: "Payload received successfully" });

        // Send the response
        check caller->respond(res);
    }

    // GET /webhook?hub.challenge=12345
    resource function get submit(http:Caller caller, http:Request req) returns error? {
        // Extract query parameter
        string hubChallenge = req.getQueryParamValue("hub.challenge") ?: "";

        // Return it as text/plain
        http:Response res = new;
        res.setTextPayload(hubChallenge, contentType = "text/plain");
        check caller->respond(res);
    }

}