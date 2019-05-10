using UnityEngine;

[ExecuteInEditMode]
[RequireComponent(typeof(Camera))]
public class PostProcessingBase : MonoBehaviour
{
	protected void CheckResources()
	{
		if (!CheckSupport())
			NotSupported();
	}

	protected bool CheckSupport()
	{
		if (SystemInfo.supportsImageEffects)
			return true;
		Debug.LogWarning("This platform does not support image effects.");
		return false;
	}

	protected void NotSupported()
	{
		enabled = false;
	}

	protected void Start()
	{
		CheckResources();
	}

	protected Material CheckShaderAndCreateMaterial(Shader shader, Material material)
	{
		if (shader == null || !shader.isSupported)
			return null;

		if (shader.isSupported && material && material.shader == shader)
			return material;

		material = new Material(shader) { hideFlags = HideFlags.DontSave };
		return material ? material : null;
	}
}

