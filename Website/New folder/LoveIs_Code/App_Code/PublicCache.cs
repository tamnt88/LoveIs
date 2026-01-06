using System;
using System.Web;
using System.Web.Caching;

public static class PublicCache
{
    public static T GetOrCreate<T>(string key, int minutes, Func<T> factory) where T : class
    {
        if (string.IsNullOrWhiteSpace(key))
        {
            return factory();
        }

        var cached = HttpRuntime.Cache[key];
        if (cached != null)
        {
            var typed = cached as T;
            if (typed != null)
            {
                return typed;
            }
            HttpRuntime.Cache.Remove(key);
        }

        var value = factory();
        HttpRuntime.Cache.Insert(
            key,
            value,
            null,
            DateTime.UtcNow.AddMinutes(minutes),
            Cache.NoSlidingExpiration);
        return value;
    }
}
