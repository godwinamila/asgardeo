import ballerina/http;
import ballerina/log;

# A service representing a network-accessible API
# bound to port `9090`.
service / on new http:Listener(9090) {

    # A resource for generating greetings
    # + name - name as a string or nil
    # + return - string name with hello message or error
    resource function get greeting(string? name) returns string|error {
        // Send a response back to the caller.
        if name is () {
            return error("name should not be empty!");
        }
        return string `Hello, ${name}`;
    }

    resource function post changetoken(http:Caller caller, http:Request req) returns error? {
        // Read the incoming JSON body (optional if you don't use it)
        json requestData = check req.getJsonPayload();
        log:printInfo("Incoming JSON payload: " + requestData.toJsonString());

        // Construct the response JSON
        json responseJson = {
                "actionStatus": "SUCCESS",
                "operations": [
                    // {
                    //     "op": "add",
                    //     "path": "/accessToken/claims/aud/-",
                    //     "value": "https://example.com/resource"
                    // },
                    // {
                    //     "op": "add",
                    //     "path": "/accessToken/claims/aud/-",
                    //     "value": "https://example.com/resource/extra"
                    // },
                    // {
                    //     "op": "add",
                    //     "path": "/accessToken/claims/group/-",
                    //     "value": "google_group1"
                    // }

                    {
                        "op": "add",
                        "path": "/accessToken/claims/-",
                        "value": {
                            "name": "google_groups",
                            "value": "hr-group"
                        }
                    },
                    {
                        "op": "add",
                        "path": "/accessToken/claims/-",
                        "value": {
                            "name": "google_groups",
                            "value": "finance-group"
                        }
                    }                
                ]
        };

        // Send the JSON response
        http:Response res = new;
        res.statusCode = 200;
        res.setPayload(responseJson);
        check caller->respond(res);
    }
}
