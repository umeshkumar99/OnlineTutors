using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using OnlineTutorsEntities;

namespace OnlineTutors.Areas.Admin.Controllers
{
    public class BlogContentController : Controller
    {
        // GET: Admin/PageBlog
        TutorsOnlineEntities onlinetutor = new TutorsOnlineEntities();
        // GET: Admin/PageContent
        public ActionResult Index()
        {

            List<usp_tblBlogContentGet_Result> pagecontent = onlinetutor.usp_tblBlogContentGet().ToList();
            return View(pagecontent);
        }

        [HttpGet]
        public ActionResult Create()
        {

            ViewBag.PageID = new SelectList(onlinetutor.usp_PageGetList(), "PageID", "PageName");

            return View();
        }
        [HttpPost]
        [ValidateInput(false)]
        public ActionResult Create(FormCollection frm)
        {
            try
            {
                usp_tblBlogContentGetID_Result Pagecontent = new usp_tblBlogContentGetID_Result();
                int result = 0;

                string Pagephoto = string.Empty;
                if (ModelState.IsValid)
                {
                    TryUpdateModel(Pagecontent);


                    onlinetutor.usp_tblBlogContentInsert(Pagecontent.pageid, Pagecontent.Title, Pagecontent.Keywords, Pagecontent.KeywordDesc, Pagecontent.Pageh1, Pagecontent.BlogContent, Pagecontent.displayorder, 1);
                }
                //if (result == 1)
                //{
                return RedirectToAction("Index");
                //   }

                //else
                //{
                //    ViewBag.CategoryID = new SelectList(onlinetutor.usp_CategoryGetList(), "CategoryID", "CategoryName");
                //    ModelState.AddModelError("", "Service already exists");
                //    return View("create");

                //}
            }
            catch (Exception ex)
            {
                return RedirectToAction("Index");
            }
        }


        [HttpGet]
        public ActionResult Edit(int id)
        {
            try
            {
                ViewBag.pageid = new SelectList(onlinetutor.usp_PageGetList(), "PageID", "PageName");
                usp_tblBlogContentGetID_Result Imagedetail = onlinetutor.usp_tblBlogContentGetID(id).FirstOrDefault();
                return View(Imagedetail);
            }
            catch (Exception ex)
            {
                return View();
            }
        }
        [HttpPost]
        [ValidateInput(false)]
        public ActionResult Edit()
        {
            try
            {
                usp_tblBlogContentGetID_Result PageContent = new usp_tblBlogContentGetID_Result();
                string Pagephoto = string.Empty;
                TryUpdateModel(PageContent);
                onlinetutor.usp_tblBlogContentUpdate(PageContent.ID, PageContent.pageid, PageContent.Title, PageContent.Keywords, PageContent.KeywordDesc, PageContent.Pageh1, PageContent.BlogContent, PageContent.displayorder, PageContent.Status, 1);
                return RedirectToAction("Index");
            }
            catch (Exception ex)
            {
                return View("Index");
            }
        }





    }
}