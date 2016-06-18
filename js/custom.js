
// PRELOADER JS
$(window).load(function(){
    $('.preloader').fadeOut(1000); // set duration in brackets    
});


/* template navigation
  -----------------------------------------------*/
 $('.main-navigation').onePageNav({
        scrollThreshold: 0.2, // Adjust if Navigation highlights too early or too late
        scrollOffset: 75, //Height of Navigation Bar
        filter: ':not(.external)',
        changeHash: true
    }); 

    /* NAVIGATION VISIBLE ON SCROLL */
    mainNav();
    $(window).scroll(function () {
        mainNav();
    });

    function mainNav() {
        var top = (document.documentElement && document.documentElement.scrollTop) || document.body.scrollTop;
        if (top > 40) $('.sticky-navigation').stop().animate({
            "opacity": '1',
            "top": '0'
        });
        else $('.sticky-navigation').stop().animate({
            "opacity": '0',
            "top": '-75'
        });
    }


/* HTML document is loaded. DOM is ready. 
-------------------------------------------*/
$(document).ready(function() {

 /* Hide Mobile Menu After Click on a link
 -----------------------------------------------*/ 
    $('.navbar-collapse a').click(function(){
        $(".navbar-collapse").collapse('hide');
    }); 


  /* Owl Carousel
  -----------------------------------------------*/
  $(document).ready(function() {
    $("#owl-screenshot").owlCarousel({
      items : 4,
      itemsDesktop : [1199,3],
      itemsDesktopSmall : [979,3],
      slideSpeed: 300,
    });
  });

   $(document).ready(function() {
    $("#owl-testimonial").owlCarousel({
      autoPlay: 6000,
      items : 1,
      itemsDesktop : [1199,1],
      itemsDesktopSmall : [979,1],
      itemsTablet: [768,1],
      itemsTabletSmall: false,
      itemsMobile : [479,1],
      pagination: false,
    });
  });


  /* Nivo lightbox
    -----------------------------------------------*/
  $('#screenshot .col-md-3 a').nivoLightbox({
        effect: 'fadeScale',
    });


  /* wow
  -------------------------------*/
  new WOW({ mobile: false }).init();
  
    });

