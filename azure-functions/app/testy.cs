using System;
using System.Collections;
using System.Collections.Generic;
using System.Net;
using Microsoft.Azure.Functions.Worker;
using Microsoft.Azure.Functions.Worker.Http;
using Microsoft.Extensions.Logging;
using System.Data.SqlClient;

namespace app
{
    public class testy
    {
        private readonly ILogger _logger;

        public testy(ILoggerFactory loggerFactory)
        {
            _logger = loggerFactory.CreateLogger<testy>();
        }

        [Function("testy")]
        public HttpResponseData Run([HttpTrigger(AuthorizationLevel.Anonymous, "get", "post")] HttpRequestData req)
        {
            _logger.LogInformation("C# HTTP trigger function processed a request.");
            string connetionString;
            var connValue =  Environment.GetEnvironmentVariable("connString");
            var response = req.CreateResponse(HttpStatusCode.OK);
            response.Headers.Add("Content-Type", "text/plain; charset=utf-8");
            SqlConnection cnn ;
			connetionString = connValue;
            cnn = new SqlConnection(connetionString);
            try
            {
                cnn.Open();
                Console.WriteLine("Connection Open ! ");
                response.WriteString("Welcome to Azure Functions, Connection Open !");
                cnn.Close();
            }
            catch (Exception ex)
            {
                Console.WriteLine("Can not open connection ! ");
                response.WriteString("Welcome to Azure Functions, Can not open connection !");
            }
            cnn.Close();

            return response;
        }
    }
}
