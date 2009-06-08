Unit myimg;

Interface


Const
  exclam_gif : Array[0..2641] of byte = (
      71, 73, 70, 56, 57, 97,238,  0,211,  0,247,  0,  0,  0,  0,  0,128,
       0,  0,  0,128,  0,128,128,  0,  0,  0,128,128,  0,128,  0,128,128,
     192,192,192,192,220,192,166,202,240,  4,  4,  4,  8,  8,  8, 12, 12,
      12, 17, 17, 17, 22, 22, 22, 28, 28, 28, 34, 34, 34, 41, 41, 41, 85,
      85, 85, 77, 77, 77, 66, 66, 66, 57, 57, 57,255,124,128,255, 80, 80,
     214,  0,147,204,236,255,239,214,198,231,231,214,173,169,144, 51,  0,
       0,102,  0,  0,153,  0,  0,204,  0,  0,  0, 51,  0, 51, 51,  0,102,
      51,  0,153, 51,  0,204, 51,  0,255, 51,  0,  0,102,  0, 51,102,  0,
     102,102,  0,153,102,  0,204,102,  0,255,102,  0,  0,153,  0, 51,153,
       0,102,153,  0,153,153,  0,204,153,  0,255,153,  0,  0,204,  0, 51,
     204,  0,102,204,  0,153,204,  0,204,204,  0,255,204,  0,102,255,  0,
     153,255,  0,204,255,  0,  0,  0, 51, 51,  0, 51,102,  0, 51,153,  0,
      51,204,  0, 51,255,  0, 51,  0, 51, 51, 51, 51, 51,102, 51, 51,153,
      51, 51,204, 51, 51,255, 51, 51,  0,102, 51, 51,102, 51,102,102, 51,
     153,102, 51,204,102, 51,255,102, 51,  0,153, 51, 51,153, 51,102,153,
      51,153,153, 51,204,153, 51,255,153, 51,  0,204, 51, 51,204, 51,102,
     204, 51,153,204, 51,204,204, 51,255,204, 51, 51,255, 51,102,255, 51,
     153,255, 51,204,255, 51,255,255, 51,  0,  0,102, 51,  0,102,102,  0,
     102,153,  0,102,204,  0,102,255,  0,102,  0, 51,102, 51, 51,102,102,
      51,102,153, 51,102,204, 51,102,255, 51,102,  0,102,102, 51,102,102,
     102,102,102,153,102,102,204,102,102,  0,153,102, 51,153,102,102,153,
     102,153,153,102,204,153,102,255,153,102,  0,204,102, 51,204,102,153,
     204,102,204,204,102,255,204,102,  0,255,102, 51,255,102,153,255,102,
     204,255,102,255,  0,204,204,  0,255,  0,153,153,153, 51,153,153,  0,
     153,204,  0,153,  0,  0,153, 51, 51,153,102,  0,153,204, 51,153,255,
       0,153,  0,102,153, 51,102,153,102, 51,153,153,102,153,204,102,153,
     255, 51,153, 51,153,153,102,153,153,153,153,153,204,153,153,255,153,
     153,  0,204,153, 51,204,153,102,204,102,153,204,153,204,204,153,255,
     204,153,  0,255,153, 51,255,153,102,204,153,153,255,153,204,255,153,
     255,255,153,  0,  0,204, 51,  0,153,102,  0,204,153,  0,204,204,  0,
     204,  0, 51,153, 51, 51,204,102, 51,204,153, 51,204,204, 51,204,255,
      51,204,  0,102,204, 51,102,204,102,102,153,153,102,204,204,102,204,
     255,102,153,  0,153,204, 51,153,204,102,153,204,153,153,204,204,153,
     204,255,153,204,  0,204,204, 51,204,204,102,204,204,153,204,204,204,
     204,204,255,204,204,  0,255,204, 51,255,204,102,255,153,153,255,204,
     204,255,204,255,255,204, 51,  0,204,102,  0,255,153,  0,255,  0, 51,
     204, 51, 51,255,102, 51,255,153, 51,255,204, 51,255,255, 51,255,  0,
     102,255, 51,102,255,102,102,204,153,102,255,204,102,255,255,102,204,
       0,153,255, 51,153,255,102,153,255,153,153,255,204,153,255,255,153,
     255,  0,204,255, 51,204,255,102,204,255,153,204,255,204,204,255,255,
     204,255, 51,255,255,102,255,204,153,255,255,204,255,255,255,102,102,
     102,255,102,255,255,102,102,102,255,255,102,255,102,255,255,165,  0,
      33, 95, 95, 95,119,119,119,134,134,134,150,150,150,203,203,203,178,
     178,178,215,215,215,221,221,221,227,227,227,234,234,234,241,241,241,
     248,248,248,255,251,240,160,160,164,128,128,128,255,  0,  0,  0,255,
       0,255,255,  0,  0,  0,255,255,  0,255,  0,255,255,255,255,255, 44,
       0,  0,  0,  0,238,  0,211,  0,  0,  8,255,  0,255,  9, 28, 72,176,
     160,193,131,  8, 19, 42, 92,200,176,161, 67,132,245, 50,116, 75, 64,
     177, 98,134, 12,245, 30,106,220,200,177,163,199,143, 32, 67,138, 28,
      73, 48, 67,197,147, 40, 41,210, 35,201,178,165,203,151, 48, 99,110,
     164,151,178, 38,202,140, 50,115,234,220,201,179,231,192,137, 54,131,
      82,236,230,179,168,209,163, 72, 19,214, 19,202,180, 34,206,164, 80,
     163, 74,101, 73,179,169,213,167, 83,179,106,221, 10,209,170,215,  4,
      92,195,138,213,250,245,235,216,179,104,125,150,253, 74, 52,173,219,
     183, 44, 77,174,245,154,  1,174,221,187, 27,151,206,253,138, 21,175,
     223,191,  3,247,174,  5, 76,248,175, 92,193, 94,251, 22, 94,124, 22,
     241, 96,198,144,199, 30,118,108,181,110,228,203, 89,245, 82, 54,139,
     185, 51, 84,193, 23,247, 90,246, 76,186,167,230,178, 56, 39,115, 46,
     205, 58,231,222,149,  3, 85,123,109, 77,251,101,213,178,163,  3,207,
     133, 93,187,119,200,189,138, 79,175,246, 77,124,163,236,166,185, 75,
     206, 77, 94,188,185,210,189, 10,161, 59,159,158, 80,180,194,227, 76,
     219, 82,223, 46,240,118, 89,134,192,185,115,255,151,190, 80,248,108,
     241,211,177, 11,101,142, 80,125, 80,222,232,137,147,103,104,222,106,
     252,226,238,109,178, 79,152,191,230,254,251,157,213,215, 84, 94,225,
       1,216, 90,129, 26,245, 87,147,129,172,  9,200,148, 71,175, 49, 72,
     218,124, 28, 81, 40, 33, 99, 10,162,244, 95, 67, 25,158,180,225,133,
     119, 57, 40,148, 72, 22,130,248, 23, 80,184,137,212,161, 69, 38, 22,
      38, 98, 80, 36, 33,216, 34, 94, 37,122,228,221,112, 51,194,117, 99,
     101, 45,201,152,163, 91, 62,146, 56,215,143,112,173, 72,209,135, 29,
      89, 71,100, 90, 53, 10,249,216,146, 99,161,248, 21,146, 54,206,165,
      29,148, 91,237,104,159, 76, 65, 98, 25, 85,151, 44,189,104,147,151,
      90, 25,153,  0,149, 33,153,  9, 31,153, 73, 53,217,146,152, 11,178,
       9,149,153,104,170,184,156,156, 72,193,153, 82, 81,110,226, 25, 19,
     152,  8,209, 35,145, 73, 23,205,163, 24,127,125,250,249,102,162,221,
      33,119,168, 65, 17, 42,186, 19,163,255,164, 88, 30,165,146,126,164,
      37, 83, 72,110,250,224, 66, 74,102, 10, 19,160,  2,153,233, 20,168,
      67,138,250, 82,168, 93, 57,182, 16,157,170, 46,255,154,106,116,155,
     161,186,214,163,177, 86, 56,107,117,155, 37,128,235, 63,122,162,148,
     171, 72,158,  6,117,229, 65,193, 14, 72,235,173,195,130, 68,106,165,
     189, 82,244,107,178, 21, 53,235, 17,172,182,246,250, 33,182,214,106,
     148,168,169,198, 94,186,107,183, 12,113,203,107,180, 20,149,139,169,
     181,212,166, 11, 30,186,210,190,203, 44,185,217,126,181, 38, 66,240,
     198, 43,238,147,244, 30,100,106, 67,237, 54,117,239, 65,207,118, 75,
     105,177,130, 13, 76,240,184,253,150,122,103, 67,  8,207,197,141,194,
       6,153,219,112,192, 15, 69,188,219, 67,235,102, 90,240, 64,244,112,
     147,239,175,  5,253,219, 48,176,235,  6,204, 20,201,  5,125,236,241,
      92, 44,183,156, 47,129, 12, 55,171, 49, 74,199, 54,148, 47, 88, 27,
     177,106,173,203,  4,229,155,179,206, 53,199, 42, 37, 93, 29,129,171,
      95,210, 15, 55,139,113, 71,243,192, 59, 15,132, 48,255,220, 52,205,
     209,198,124,208,205, 39, 13, 45, 41,215, 21,121,237, 16,188,206, 86,
     157, 43,208, 11, 71, 11,210,211,170, 90,204,209,209,136,137,237,144,
     219,126,118,236,111,180,117,182, 58,175,164,116,207,255,132,183,157,
     107,201,141,165,221,200,102, 61, 18,218, 38, 70,234, 36,101, 36,177,
      45, 39,216,213,198,216,107, 92, 27,227, 73, 56,162,181, 54,126,249,
     125,125, 87, 73, 89,222,234,174,  5, 58,128,142,143,164,178,135, 46,
     109, 46,158,153, 83,167, 78,153,214, 15,117,110, 98,233,146,187,186,
     170,217, 75, 34, 62, 55,227, 47,209,222, 34,228,  9,  8,254,145,210,
     238,222, 46,122,238,184,187,  4, 60,234,127, 22, 45,161,236, 33,157,
     126,166, 76,208,199,231,123,143,136,193,158,164,243,  0,250,108,188,
     234, 16,131, 79,219,245, 45, 41, 61,105,242, 12,138,207, 33, 98, 60,
     169, 79, 90,245,166,131,198, 19,252,206,233, 78,245,213, 50,145,191,
      29,253,135,219,207,116,224,233,227,222,247,190,163, 22,244,113,  7,
     110,  2, 43,138,201,122,178,188,251, 52,176, 40, 81, 59,158,  2, 43,
      39, 30,255,125,164, 93,163,139,158,251, 10,179, 64, 62,237,205, 39,
     252, 43,205,  6,123,246,193,  2,242,203, 57, 33,108,  9,  2, 71,132,
     148, 20, 94, 70,127, 58, 49,210,103, 12,216, 27, 11, 18,203, 82,121,
      26, 33, 92, 96,168,147,100,101,144, 37,138,243,141, 14,255,183,231,
      21,138,245,100,136,104,  1,222, 15,177,151, 24,169,184,144, 48, 72,
     124, 27,142,218, 68, 67,207,120,175,133, 83, 68,202,  3, 91,195, 67,
       6, 34, 45, 43, 54,124, 75, 24,195,244, 69, 48, 10,112, 49, 74,228,
      74, 17,183,178, 66,161, 24,113, 49, 99,100,226,202,182,210, 69,195,
     224,111, 42, 10, 10,203, 19,129,116,198,163,192, 73, 44, 65,132, 76,
      27,223, 35, 22, 49, 45, 81, 38, 91,132, 76, 29,143,130,156,177,  4,
     178, 48,113, 28, 21, 83,222,152,148, 69,166, 37,145,122,156,163,100,
     238,248,151, 40,146, 36, 63, 76,234, 99, 90,  6,185, 52,180,188, 40,
      45,102, 18,158, 41, 61,  9,196,160, 28,178,125, 85, 20, 35,  5,209,
     178, 30,183, 88,146,142,172,108,165, 77, 40, 57,149, 72,122,240,132,
     104, 81,143,246,102,  8, 76,183,164, 17, 46, 17,140,211, 91,246, 72,
     197, 18,174,114, 76,118,241,101, 12, 57, 73, 75,255,220,  5,120,170,
     156,202, 45,123, 89, 19, 94,110, 69,154,205, 91,139, 55,217, 88,147,
      97, 74,101,155, 70,193,100,145,148,121, 23, 53,133,178,152,111, 73,
     230, 73,254,130,206,158, 48, 51, 42,230,121,101, 82,238,233,255, 26,
      81, 58, 82, 67, 80,140,229,156,168,  9,151,148,180,206,142,254, 52,
      77, 46,117,114, 52,115,126,115,150,220,116, 38, 94, 84,179,152,122,
     194,196,162, 90,137,200, 69, 46,130, 33,130, 26,101,161,100,  2,105,
     232,112,120,178,245, 73, 16, 42,  1,115,104,191,192,185, 17, 82,118,
     179,164, 88, 35, 96, 14, 19, 10, 83,129,176,116,108, 52,173,169, 77,
     115, 58,146, 99,234, 52, 65, 30, 13, 39,106,126, 26,211, 44,230,132,
     159, 37,237, 96, 15, 69, 42,170,155,166,173, 44,227,124,139, 70, 61,
     132,145,206,128, 84,157,132,137,152, 62,203, 20,212,254, 73,212, 47,
     201, 58,168,139,114,137, 84, 60,118,117,153,103,253,136, 83, 65,200,
      62,198,120,178,172, 81, 33, 30,207, 10,131,205,139, 50, 53, 38,203,
     195,153, 91, 33,234,213,161,194,177, 87, 81, 45,164, 14, 49,154, 21,
     185,206,243,175, 39,237, 43, 95, 42, 10, 47,149, 62, 20,158,255, 35,
      41, 96, 12,219,181,142, 38,182,108, 95,189,203,206, 32, 51,198, 43,
     250,101,103,142,205, 40,248,  8, 75,150,124,109, 85, 42,143,244,150,
      64,237,146,215, 90,114,150,167,141,  2, 32,100, 90,235,202,200,255,
     236,113,173, 69,161,109, 41, 25,131, 78,184,106,115,103,167, 53,107,
      78,239,122, 62,120,  5,246,157,126,117,136, 75, 83, 18, 92, 51,146,
      13, 51,139, 36,109, 88,150, 43,211,203,164,246,169,246,242,140,110,
       1,106,197, 62, 42,213,186,232, 42, 77,245,136,235,147,237, 30,137,
      53,125,242,173, 88, 40,219,154,186,234,173,186, 34,124, 29,109,192,
     228,206,241, 57,166,185, 99,241,157,116,165, 42,191, 26,222, 17,183,
      97, 89,173, 85,199,133, 65,231,220, 12,191,104, 77, 44,128,207, 34,
     168,218, 82,135, 60, 62,221,142, 70, 47, 18,218,200,  0,175,117,212,
      61, 44, 81, 27,147, 42,  1,111,248, 75,131,105,215,135, 81, 41, 78,
      25,142,248,153, 83,186,236,137, 51,185,179, 83,173,184,154, 45,158,
     235,139,255,217, 98,  4,207,152,114, 53,190,241, 89, 40,171,159, 10,
     235,184, 37,244,200,112,140,135, 76,228, 34, 27,249,200, 72, 78,178,
     146,151,204,228, 38,195,139,199, 78,142,178,148,167,252,100,233, 81,
     249,202, 88,206,242, 80,181,204,229, 46,123,217,118, 80,254,178,152,
     199,108,100,203, 88,153,204,104, 78,115,139,149,163,230, 54,187,153,
      55,201,201,121,179,156,231, 76,100,236,210,249,206,120,118, 94,158,
     247,204,103,101,157,171,207,128,238, 51,209,  2, 77,104, 58,215, 41,
     204,133, 78,116,145, 71,135,104, 69, 59,250,111,154,106,244,163, 39,
      61,165,134,  4,  4,  0, 59);

procedure mImgOut;

Implementation

uses
 {$IFDEF STATIC}
   pwumain;
 {$ELSE}
   dynpwu;
 {$ENDIF}

procedure mImgOut;
begin
  SetWebHeader('Content-Type', 'image/gif');
  WebResourceOut(exclam_gif, SizeOf(exclam_gif));
end;


end.
