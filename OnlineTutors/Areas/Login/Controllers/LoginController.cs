using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using OnlineTutorsEntities;
namespace OnlineTutors.Areas.Login.Controllers
{
    public class LoginController : Controller
    {
        // GET: Login/Login
        TutorsOnlineEntities onlinetutor = new TutorsOnlineEntities();
        public ActionResult Index()
        {
            return View();
        }
        [HttpGet]
        public JsonResult CheckLogin(string usename, string password)
        {

        USP_GetUserDetails_Result userdetails=    onlinetutor.USP_GetUserDetails(usename, password).FirstOrDefault();
           //return RedirectToAction("Index", "Category", new { area = "Admin" });
               return Json(userdetails,JsonRequestBehavior.AllowGet);
        }
    }
}