using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using OnlineTutorsEntities;

namespace OnlineTutors.Areas.Admin.Controllers
{
    public class PageContentController : Controller
    {

        TutorsOnlineEntities onlinetutor = new TutorsOnlineEntities();
        // GET: Admin/PageContent
        public ActionResult Index()
        {
              
            List<usp_tblPageContentGet_Result> pagecontent = onlinetutor.usp_tblPageContentGet().ToList();
            return View(pagecontent);
        }

        [HttpGet]
        public ActionResult Create()
        {

            ViewBag.PageID = new SelectList(onlinetutor.usp_PageGetList(), "PageID", "PageName");

            return View();
        }
        [HttpPost]
        public ActionResult Create(FormCollection frm)
        {
            try
            {
                usp_tblPageContentGetID_Result Pagecontent = new usp_tblPageContentGetID_Result();
                int result = 0;

                string Pagephoto = string.Empty;
                if (ModelState.IsValid)
                {
                    TryUpdateModel(Pagecontent);
                    

                    result = (int)onlinetutor.usp_tblPageContentInsert(Pagecontent.pageid, Pagecontent.Title, Pagecontent.Keywords, Pagecontent.KeywordDesc, Pagecontent.Pageh1, Pagecontent.pagecontent, Pagecontent.displayorder,1).FirstOrDefault();
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
                usp_tblPageContentGetID_Result Imagedetail = onlinetutor.usp_tblPageContentGetID(id).FirstOrDefault();
                return View(Imagedetail);
            }
            catch (Exception ex)
            {
                return View();
            }
        }
        [HttpPost]
        public ActionResult Edit()
        {
            try
            {
                usp_tblPageContentGetID_Result PageContent = new usp_tblPageContentGetID_Result();
                string Pagephoto = string.Empty;
                TryUpdateModel(PageContent);
                 int result = (int)onlinetutor.usp_tblPageContentUpdate(PageContent.ID, PageContent.pageid, PageContent.Title, PageContent.Keywords, PageContent.KeywordDesc, PageContent.Pageh1, PageContent.pagecontent, PageContent.displayorder,1, PageContent.Status).FirstOrDefault();
                return RedirectToAction("Index");
            }
            catch (Exception ex)
            {
                return View("Index");
            }
        }






    }
}