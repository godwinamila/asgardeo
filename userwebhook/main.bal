import ballerina/http;
import ballerina/log;

service /api on new http:Listener(8080) {

    // POST /api/submit
    resource function post submit(http:Caller caller, http:Request req) returns error? {
        json payload = check req.getJsonPayload();
        log:printInfo("Received payload: " + payload.toJsonString());
    }
}