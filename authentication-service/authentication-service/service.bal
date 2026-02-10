import ballerina/http;
import ballerina/io;

# A service representing a network-accessible API
# bound to port `9090`.
service / on new http:Listener(9090) {

  

    # A POST resource that accepts application/json
    # + return - json acknowledgement containing the received payload or an error
    @http:ResourceConfig {
        consumes: ["application/json"]
    }
    resource function post authenticate(http:Request req) returns http:Response|error {

        // string authorization = req.getHeader("Authorization");
        // io:println("##################### Received Headers: " + authorization);
        
        io:println(req.getHeader("Authorization"));

       json|error payload = req.getJsonPayload();
       io:println("Received payload: ", req.getJsonPayload());
        if (payload is json) {
            // Extract "email" from the JSON            
            string email = (check payload.email).toString();            
            io:println("Received email: ", email);
            check createUser(email);
        }         
        http:Response res = new;
        //json response =  {"actionStatus": "SUCCESS"};
        // json response = { message: "Received JSON payload", data: payload };
        res.statusCode = 404;
        res.setPayload({ "actionStatus": "SUCCESS", "message": "Blocked email domain" });
        return res;
    }

    resource function post sendsms(http:Request req) returns http:Response|error {
        
       io:println("Received payload: ", req.getJsonPayload());
        http:Response res = new;
        res.statusCode = 200;
        res.setPayload({ "actionStatus": "SUCCESS", "message": "received SMS" });
        return res;
    }
  
}

function createUser(string email) returns error?{
        // string url = string `localhost:9443`; //IS
        string url = string `api.eu.asgardeo.io`;        

        //{"Operations":[{"op":"replace","value":{"urn:scim:wso2:schema":{"emailVerified":true}}},{"op":"replace","value":{"urn:scim:wso2:schema":{"phoneVerified":true}}}],"schemas":["urn:ietf:params:scim:api:messages:2.0:PatchOp"]}
        json newUser = {
            "userName": "DEFAULT/" + email,
            "password": "test",
            "name": {
                "givenName": "New",
                "familyName": "User"
            },
            
            "emails": [
                {
                    "primary": true,
                    "value": "test",
                    "type": "home"
                }
            ],
            "urn:scim:wso2:schema": {

                "emailVerified": {
                     "value": "true"
                }
            }
        };

        io:println("######################newUser: ", newUser);

       
        http:Client httpClient = check new (url,
            auth = {
                username: "test",
                password: "test"
            }
            // ,
            // secureSocket = {
            //     cert: "localhost.pem"
            // }
        );
        
        http:Response response = check httpClient->/t/godwineu/scim2/Users.post(newUser);
        io:println("Status: ", response.statusCode);
        io:println("Response: ", check response.getTextPayload());
}

