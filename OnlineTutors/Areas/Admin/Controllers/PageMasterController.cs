using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using OnlineTutorsEntities;
using System.IO;

namespace OnlineTutors.Areas.Admin.Controllers
{
    public class PageMasterController : Controller
    {
        // GET: Admin/PageMaster
        TutorsOnlineEntities onlinetutor = new TutorsOnlineEntities();
        // GET: Admin/Category
        public ActionResult Index()
        {
            try
            {
                List<usp_PageGet_Result> pagelist = onlinetutor.usp_PageGet().ToList();
                return View(pagelist);
            }
            catch (Exception ex)
            {
                return View();
            }
        }

        [HttpGet]
        public ActionResult Edit(int pageid)
        {
            try
            {
                usp_PageGetbyID_Result pagedetail = onlinetutor.usp_PageGetbyID(pageid).FirstOrDefault();
                return View(pagedetail);
            }
            catch (Exception ex)
            {
                return View();
            }
        }
        [HttpPost]
        public ActionResult Edit(FormCollection frm)
        {
            try
            {
                usp_PageGetbyID_Result page = new usp_PageGetbyID_Result();
                TryUpdateModel(page);
                int result = (int)onlinetutor.usp_PageUpdate(page.PageID, page.PageName, 1,page.Status).FirstOrDefault();

                if(result==1)

                return RedirectToAction("Index");
                else
                {
                    ViewBag.error = "Unable to update Page Name";
                    return RedirectToAction("Edit");
                }
            }
            catch (Exception ex)
            {
                return View("Index");
            }
        }

        [HttpGet]
        public ActionResult Create()
        {
            return View();
        }
        [HttpPost]
        public ActionResult Create(FormCollection frm)
        {
            try
            {
                int result = (int)onlinetutor.usp_PageInsert(frm["PageName"], 1).FirstOrDefault();


             //   List<FileDetail> fileDetails = new List<FileDetail>();
                //for (int i = 0; i < Request.Files.Count; i++)
                //{
                //    var file = Request.Files[i];


                //    if (file != null && file.ContentLength >= 0)
                //    {
                //        var fileName = Path.GetFileName(file.FileName);

                //        Guid Id = Guid.NewGuid();

                //        string path = Server.MapPath("~/Images/") + Id.ToString() + Path.GetExtension(fileName);
                //        file.SaveAs(path);
                //    }
                //}

                if (result == 1)
                    return RedirectToAction("Index");
                else
                {
                    ModelState.AddModelError("", "Page already exists");
                    return RedirectToAction("Create");
                }
            }
            catch (Exception ex)
            {
                return RedirectToAction("Index");
            }
        }
    }
}