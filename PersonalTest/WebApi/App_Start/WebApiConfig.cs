using Microsoft.AspNetCore.Cors;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.Http;
using WebApi.Filter;

namespace WebApi
{
    public static class WebApiConfig
    {
        public static void Register(HttpConfiguration config)
        {
            // Web API configuration and services
          
            // Web API routes
            config.MapHttpAttributeRoutes();

            config.Routes.MapHttpRoute(
                name: "DefaultApi",
                routeTemplate: "{controller}/{Action}/{id}",
                defaults: new { id = RouteParameter.Optional }
            );
            config.Filters.Add(new WebApiExceptionFilterAttribute());
            // config.Routes.MapHttpRoute(
            //    name: "DefaultApi1",
            //    routeTemplate: "{controller}/{action}/{id}",
            //    defaults: new { action = "get", id = RouteParameter.Optional }
            //);
        }
    }
}
