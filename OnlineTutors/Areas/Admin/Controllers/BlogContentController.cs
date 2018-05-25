using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace OnlineTutors.Areas.Admin.Controllers
{
    public class BlogContentController : Controller
    {
        // GET: Admin/PageBlog
        public ActionResult Index()
        {
            return View();
        }
    }
}