using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace OnlineTutors.Areas.Admin.Controllers
{
    public class PageContentController : Controller
    {
        // GET: Admin/PageContent
        public ActionResult Index()
        {
            return View();
        }
    }
}