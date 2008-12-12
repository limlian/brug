功能:新用户注册
  为了使用brug网站提供的服务
  作为来到brug网站的新用户
  我希望能够通过注册来成为brug的用户

  场景:注册一个系统中没有的用户名
    假如系统中没有email为demo@example.com的用户
    当我访问/users/new页面
    而且我填入demo@example.com的注册信息
    而且我点击Register按钮
    那么系统中将有email为demo@example.com的用户
    而且我应该到达login/index页面
    而且我应该看到Registration successed的信息
    
  场景:注册一个系统中已经存在的用户名
    假如系统中已经有email为demo@example.com的用户
    当我访问/users/new页面
    而且我填入demo@example.com的注册信息
    而且我点击Register按钮
    那么我应该到达users/new页面
    而且我应该看到Registration failed的信息
    而且我应该看到Email has been used的信息