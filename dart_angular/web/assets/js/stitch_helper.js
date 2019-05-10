function initializeDefaultAppClient(app_id)
{
	return stitch.Stitch.initializeDefaultAppClient(app_id);
}

function loginAnonymouse(client)
{
	return client.auth.loginWithCredential(new stitch.AnonymousCredential())
}