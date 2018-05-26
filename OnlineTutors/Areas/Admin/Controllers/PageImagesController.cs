using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using OnlineTutorsEntities;
using System.IO;

namespace OnlineTutors.Areas.Admin.Controllers
{
    public class PageImagesController : Controller
    {
        // GET: Admin/PageImages
        TutorsOnlineEntities onlinetutor = new TutorsOnlineEntities();

        // GET: Admin/Category
        public ActionResult Index()
        {
            try
            {
                List<usp_tblPageImagesGet_Result> Imagelist = onlinetutor.usp_tblPageImagesGet().ToList();
                return View(Imagelist);
            }
            catch (Exception ex)
            {
                return View();
            }
        }

        [HttpGet]
        public ActionResult Edit(int Imageid)
        {
            try
            {
                ViewBag.PageID = new SelectList(onlinetutor.usp_PageGetList(), "PageID", "PageName");
                usp_tblPageImagesGetbyID_Result Imagedetail = onlinetutor.usp_tblPageImagesGetbyID(Imageid).FirstOrDefault();
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
                usp_tblPageImagesGetbyID_Result PageImage = new usp_tblPageImagesGetbyID_Result();
                string Pagephoto = string.Empty;
                TryUpdateModel(PageImage);
                var fp = Request.Files["ImageURL"];

                if (fp != null && fp.ContentLength >= 0)
                {
                    var fileName = Path.GetFileName(fp.FileName);
                    if (fileName != null && !string.IsNullOrEmpty(fileName.ToString()))
                    {
                        Guid Id = Guid.NewGuid();

                        Pagephoto = Server.MapPath("~/Images/") + Id.ToString() + Path.GetExtension(fileName);

                        fp.SaveAs(Pagephoto);
                        Pagephoto = "~/Images/" + Id.ToString() + Path.GetExtension(fileName);
                        fp = null;
                    }
                }
                int result = (int)onlinetutor.usp_tblPageImagesUpdate(PageImage.Imageid, Pagephoto, PageImage.DisplayOrder,PageImage.PageID,PageImage.status,1).FirstOrDefault();
                return RedirectToAction("Index");
            }
            catch (Exception ex)
            {
                return View("Index");
            }
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
                usp_tblPageImagesGetbyID_Result PageImage = new usp_tblPageImagesGetbyID_Result();
                int result = 0;
                
                string Pagephoto = string.Empty;
                if (ModelState.IsValid)
                {
                    TryUpdateModel(PageImage);
                    var fp = Request.Files["ImageURL"];
                   
                    if (fp != null && fp.ContentLength >= 0)
                    {
                        var fileName = Path.GetFileName(fp.FileName);
                        Guid Id = Guid.NewGuid();
                       
                        Pagephoto = Server.MapPath("~/Images/") + Id.ToString() + Path.GetExtension(fileName);
                      
                        fp.SaveAs(Pagephoto);
                        Pagephoto = "~/Images/" + Id.ToString() + Path.GetExtension(fileName);
                        fp = null;
                    }

                    result = (int)onlinetutor.usp_tblPageImagesInsert(Pagephoto, PageImage.DisplayOrder,PageImage.PageID, 1).FirstOrDefault();
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


    }
}