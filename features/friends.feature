功能:朋友管理
  为了和我的朋友保持联系
  作为brug网站的用户
  我希望能够管理我在brug网站上朋友

  场景:添加好友
    假如系统中没有用户
    而且系统添加demo1@example.com用户
    而且系统添加demo2@example.com用户
    而且demo1@example.com用户没有朋友
    当我用demo1@example.com用户登录
    而且访问demo1@example.com用户页面
    那么我应该在friends-list列表里面看不到demo2@example.com用户

    当我用demo1@example.com用户登录
    而且访问demo2@example.com用户页面 
    而且我点击Add as friend按钮
    而且访问demo1@example.com用户页面
    那么我应该在friends-list列表里面看不到demo2@example.com用户

    当我用demo2@example.com用户登录
    而且访问demo2@example.com的消息页面
    那么我应该看到demo1@example.com的添加好友请求
    
    当我用demo2@example.com用户登录
    而且访问demo2@example.com的消息页面
    而且我点击Accept按钮
    而且访问demo2@example.com用户页面
    那么我应该在friends-list列表里面看到demo1@example.com用户

    当我用demo1@example.com用户登录
    而且访问demo1@example.com用户页面
    那么我应该在friends-list列表里面看到demo2@example.com用户