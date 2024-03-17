# v2_1

Comfy Space 2.1

## Tips:

1. When using Futurebuilder + calling data from firestore, put the Future<> get_data function in the initState as a variable & pass that as the future for FutureBuilder. This prevents query whenever screen changes -> faster load/animation & lower bills (only reading once)
    ```
   class _HomeScreenState extends State<HomeScreen> {
    var user_info;
    @override
    void initState() {
        user_info = get_user_information();
        super.initState();
                        }
    int _selectedPageIndex = 0;
    @override
    Widget build(BuildContext context) {
        return FutureBuilder<user_information>(
            future: user_info,
            builder: (BuildContext context, snapshot){
                if(snapshot.connectionState == ConnectionState.done){ ...
```
