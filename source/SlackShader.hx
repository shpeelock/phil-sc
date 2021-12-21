package;

import flixel.system.FlxAssets.FlxShader;
import openfl.display.BitmapData;
import openfl.display.ShaderInput;
import openfl.utils.Assets;
import flixel.FlxG;
import openfl.Lib;



class SlackShader extends FlxShader // https://www.shadertoy.com/view/ldjGzV and https://www.shadertoy.com/view/Ms23DR and https://www.shadertoy.com/view/MsXGD4 and https://www.shadertoy.com/view/Xtccz4
{

  @:glFragmentSource('

        #pragma header

        uniform float iTime;
        uniform bool vignetteOn;
        uniform bool perspectiveOn;
        uniform bool distortionOn;
        uniform bool scanlinesOn;
        uniform bool vignetteMoving;
        uniform sampler2D noiseTex;
        uniform float glitchModifier;
        uniform vec3 iResolution;

        vec4 getVideo(vec2 uv)
            {
                vec2 look = uv;

                vec4 video = flixel_texture2D(bitmap,look);

                return video;
            }

        vec2 screenDistort(vec2 uv)
        {
            if(perspectiveOn){
            uv = (uv - 0.5) * 2.0;
                uv *= 1.1;
                uv.x *= 1.0 + pow((abs(uv.y) / 5.0), 2.0);
                uv.y *= 1.0 + pow((abs(uv.x) / 4.0), 2.0);
                uv  = (uv / 2.0) + 0.5;
                uv =  uv *0.92 + 0.04;
                return uv;
            }
            return uv;
        }

        void main()
        {
            vec2 uv = openfl_TextureCoordv;
            vec2 curUV = screenDistort(uv);
            vec4 video = getVideo(uv);
            float vigAmt = 1.0;
            float x =  0.;


            video.r = getVideo(vec2(x+uv.x+0.001,uv.y+0.001)).x+0.05;
            video.g = getVideo(vec2(x+uv.x+0.000,uv.y-0.002)).y+0.05;
            video.b = getVideo(vec2(x+uv.x-0.002,uv.y+0.000)).z+0.05;

            video = clamp(video*0.6+0.4*video*video*1.0,0.0,1.0);
            gl_FragColor = mix(video,vec4(noise(uv * 75.)),.05);

            if(curUV.x<0. || curUV.x>1. || curUV.y<0. || curUV.y>1.){
            gl_FragColor = vec4(0,0,0,0);
            }

        }
  ')
  public function new()
  {
    super();
  }
}