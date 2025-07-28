page_texts = [
	"You wake up in complete darkness, realizing you are the soul of a cat. But you've lost your memory. You know nothing except that you're a feline spirit. Suddenly, a voice speaks:",

	" <<< Hello there, little one. I am Death. Stop looking, you can't see me. I'm here to guide you to the afterlife. However... it seems you've forgotten everything, including how you died. I cannot lead you onward if you cannot tell the cuase of your death. So, yeah, try remember! >>>",
	
	"Rules: Drag the pictures on the left side of the screen to the blank squares on the main screen area. Each picture descirbes a single incident, and each incident leads to the another, and finally to your cause of death. Use the check Button to see how many cards are on the correct position",

	"If you are ready, press [SPACE] to start exploring."
];

current_page = 0; 

text_color = c_white;
text_alpha = 1;

current_page = clamp(current_page, 0, array_length(page_texts) - 1);

fade_alpha = 1;     
ease_in = 0.005;
ease_out = 0.05;
is_fading = false;   
next_page = 0;      