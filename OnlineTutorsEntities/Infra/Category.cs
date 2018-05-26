using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.ComponentModel.DataAnnotations;

namespace OnlineTutorsEntities
{
    [MetadataType(typeof(Category))]
    public partial class usp_CategoryGetbyID_Result
    {

    }

    public class login
    {
        public string loginID { get; set; }
        public string Password { get; set; }

    }
    public class Category
    {
        public int CategoryID { get; set; }
        [Required]
        [MaxLength(100, ErrorMessage = "Category Name cannot be greater than 100 characters")]
        public string CategoryName { get; set; }
        public Nullable<bool> Status { get; set; }
        public Nullable<int> CreatedByID { get; set; }
        public string CreatedBy { get; set; }
        public Nullable<System.DateTime> CreatedOn { get; set; }
        public Nullable<int> UpdatedByID { get; set; }
        public string UpdatedBy { get; set; }
        public Nullable<System.DateTime> UpdatedOn { get; set; }
    }
}