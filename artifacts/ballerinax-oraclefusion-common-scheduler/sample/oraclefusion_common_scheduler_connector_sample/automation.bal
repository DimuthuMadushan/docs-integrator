import ballerina/log;
import ballerinax/oraclefusion.common.scheduler;

public function main() returns error? {
    do {
        scheduler:RequestQueryResponse jobRequests = check schedulerClient->queryJobRequests(q = "state eq \"RUNNING\"", orderBy = "submissionTime:desc");
        log:printInfo(string `Running job requests: ${jobRequests.count ?: 0}`);
    } on fail error e {
        log:printError("Error occurred", 'error = e);
        return e;
    }
}
