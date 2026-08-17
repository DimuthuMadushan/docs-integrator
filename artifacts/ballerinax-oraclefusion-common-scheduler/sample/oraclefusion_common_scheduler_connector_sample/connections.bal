import ballerinax/oraclefusion.common.scheduler;

final scheduler:Client schedulerClient = check new ({auth: {tokenUrl: tokenUrl, clientId: clientId, clientSecret: clientSecret}}, string `${serviceUrl}`);
