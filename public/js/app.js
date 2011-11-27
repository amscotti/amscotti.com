$(function() {

  $(".text").hide();
  $(".header").click(function() {
  	$(this).next().slideToggle("fast");
  	$(this).toggleClass("closed expanded");
  });

  $("#self_image img").hover(function() {
      $(".self").toggle();
  });

  $("#lifestream").lifestream({
    limit: 10,
    list:[{service: "github",
      user: "amscotti",
    },{service: "twitter",
      user: "amscotti"
    },{service: "wordpress",
        user: "http://www.128bitstudios.com/"
      }]
  });
  
  $("#contact").submit(function() {
    $("#status").hide();
    $("#status").empty();
    
    $.post("/contact", $("#contact").serialize(),
      function(data) {
        if(data.status === "ok"){
            $("#status").append("Message sent!");
            $("#status").show("slow");
            $("#contact").each(function(){
                this.reset();
            });
      } else {
        $("#status").append("Error, message not sent!");
        $("#status").show("slow");
      }
    });
    return false;
  });  
});