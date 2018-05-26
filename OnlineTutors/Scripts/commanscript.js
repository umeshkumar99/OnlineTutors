
function readURL(input, target) {
    //        debugger;
    if (input.files && input.files[0]) {
        var reader = new FileReader();

        reader.onload = function (e) {
            target.attr('src', e.target.result).css('display', 'block');
            //$('#blah').attr('src', e.target.result).css('display','block');
        }
        reader.readAsDataURL(input.files[0]);
    }
}



