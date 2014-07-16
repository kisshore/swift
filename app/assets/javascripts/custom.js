$( document ).ready(function() {
  var count = 1;
  
  $(".create_obj").click(function(){
    console.log("Hello world!");
    console.log($(this).data("container"));
     $("#add_obj_meta").append("<input name='container_name' type='hidden' value='"+$(this).data("container") +"'>");
    
    
  });
  
  $('#add_obj_meta_btn').click(function(){
    $("#add_obj_meta").append(" <div class='form-group'><label for='name' class='col-lg-2 control-label'>Meta :</label><div class='col-lg-5'><input class='form-control' id='meta[name_"+count+"]'"+" name='meta[name_"+count+"]'"+" placeholder='Meta Name' type='text'></div><div class='col-lg-5'><input class='form-control' id='meta[value_"+count+"]'"+" name='meta[value_"+count+"]'"+" placeholder='Meta value' type='text'></div>");
    count = count+1;
  });
  
  
});
