interface IModule {

	void initialize();
	
	IOption getInstance(Type type);
	
	bool binds(Type type);
}