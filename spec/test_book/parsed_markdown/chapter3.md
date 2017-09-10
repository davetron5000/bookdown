Let's take a screenshot:

![Some image](images/image.png)

Now, let's `ls`:

```shell
> ls -1
index.html
```

And who can forget `package.json`:

```json
{
}
```

```json
{
  "scripts": {
    "webpack": "$(yarn bin)/webpack"
  }
}
```

One more change to `package.json`:

```json
{
  "config": {
    "webpack_args": " --config webpack.config.js --display-error-details"
  }
}
```

Let's much once more:


![Updated image](images/updated.png)
