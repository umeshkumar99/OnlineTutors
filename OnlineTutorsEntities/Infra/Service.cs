using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.ComponentModel.DataAnnotations;

namespace OnlineTutorsEntities
{
    [MetadataType(typeof(Service))]
    public partial class usp_ServiceGetbyID_Result
    {

    }

    public class Service
    {
        public int ServiceID { get; set; }
        [Required]
        [MaxLength(100, ErrorMessage = "Service Description cannot be greater than 100 characters")]
        
        public string Description { get; set; }
        public string CategoryName { get; set; }
        public Nullable<int> CategoryID { get; set; }
        public Nullable<bool> Status { get; set; }
        public Nullable<int> CreatedByID { get; set; }
        public string CreatedBy { get; set; }
        public Nullable<System.DateTime> CreatedOn { get; set; }
        public Nullable<int> UpdatedByID { get; set; }
        public string UpdatedBy { get; set; }
        public Nullable<System.DateTime> UpdatedOn { get; set; }
    }
}