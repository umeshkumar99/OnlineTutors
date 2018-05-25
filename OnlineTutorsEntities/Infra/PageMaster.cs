using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.ComponentModel.DataAnnotations;

namespace OnlineTutorsEntities
{
    [MetadataType(typeof(Page))]
    public partial class usp_PageGetbyID_Result
    {

    }

    public class Page
    {
       
        public int PageID { get; set; }
        [Required]
        [MaxLength(100, ErrorMessage = "Page Name cannot be greater than 100 characters")]
        public string PageName { get; set; }
        public Nullable<bool> Status { get; set; }
        public Nullable<int> CreatedByID { get; set; }
        public string CreatedBy { get; set; }
        public Nullable<System.DateTime> CreatedOn { get; set; }
        public Nullable<int> UpdatedByID { get; set; }
        public string UpdatedBy { get; set; }
        public Nullable<System.DateTime> UpdatedOn { get; set; }
        
    }
}