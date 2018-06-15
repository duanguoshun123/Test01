using System.Web.Http;
using WebActivatorEx;
using WebApi;
using Swashbuckle.Application;

[assembly: PreApplicationStartMethod(typeof(SwaggerConfig), "Register")]

namespace WebApi
{
    public class SwaggerConfig
    {
        public static void Register()
        {
            var thisAssembly = typeof(SwaggerConfig).Assembly;

            GlobalConfiguration.Configuration
                .EnableSwagger(c =>
                    {
                        c.SingleApiVersion("v1", "WebApi");
                        c.IncludeXmlComments(string.Format("{0}/bin/WebApi.XML", System.AppDomain.CurrentDomain.BaseDirectory));
                    })
                .EnableSwaggerUi(c =>
                    {
                        //GetXmlCommentsPath();
                        c.InjectJavaScript(thisAssembly, "WebApi.scripts.swaggerui.swagger_lang.js");
                    });
        }
        private static string GetXmlCommentsPath()
        {
            return $@"{System.AppDomain.CurrentDomain.BaseDirectory}\bin\WebApi.XML";
        }
    }
}
