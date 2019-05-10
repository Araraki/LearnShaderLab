﻿using System.Collections;
using UnityEditor;
using UnityEngine;

public class RenderCubeMap : ScriptableWizard
{
	public Transform renderFromPosition;
	public Cubemap cubemap;

	void OnWizardCreate()
	{
		GameObject go = new GameObject("CubemapCamera");
		go.AddComponent<Camera>();
		go.transform.position = renderFromPosition.position;
		go.transform.rotation = Quaternion.identity;
		go.GetComponent<Camera>().RenderToCubemap(cubemap);
		DestroyImmediate(go);
	}

	void OnWizardUpdate()
	{
		//string helpString = "Select transform to render from and cubemap to render into";
		bool isValid = (renderFromPosition != null) && (cubemap != null);
	}

	[MenuItem("GameObject/Render into Cubemap")]
	static void RenderCubemap()
	{
		ScriptableWizard.DisplayWizard<RenderCubeMap>("Render cubemap", "Render!");
	}
}
