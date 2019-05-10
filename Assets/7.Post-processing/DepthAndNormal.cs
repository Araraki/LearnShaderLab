using UnityEngine;

public class DepthAndNormal : PostProcessingBase
{
	public Shader depthAndNormalShader;
	private Material depthAndNormalMaterial;
	public Material material
	{
		get
		{
			depthAndNormalMaterial = CheckShaderAndCreateMaterial(depthAndNormalShader, depthAndNormalMaterial);
			return depthAndNormalMaterial;
		}
	}

	public bool showDepth = false;
	public bool showNormal = false;

	void OnEnable()
	{
		//GetComponent<Camera>().depthTextureMode = DepthTextureMode.Depth;
		GetComponent<Camera>().depthTextureMode |= DepthTextureMode.DepthNormals;
	}

	void OnRenderImage(RenderTexture src, RenderTexture dest)
	{
		if (material != null)
		{
			material.SetFloat("_DepthActive", showDepth ? 1 : 0);
			material.SetFloat("_NormalActive", showNormal ? 1 : 0);
			Graphics.Blit(src, dest, material);
		}
		else
		{
			Graphics.Blit(src, dest);
		}
	}
}
