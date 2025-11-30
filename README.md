# Application Deployment in ECP architecture

My goal with this small project was to gather and put together several pieces and build quickly a full ECP architecture where we could test our applications.

## What's in there?

By default, once you install it, it'll launch:

- _1 ECP Data Server_
- _3 ECP APP Servers_ connected to the ECP Data Server
- _1 Load Balancer (WebGateway configured as such)_ pointing at the ECP APP Servers.

As part of the installation, each ECP APP Server will start with the following functionalities already installed(*):

- ZPM
- WebTerminal
- Restforms2
- Restforms2-ui
- OPNEx-MModel

_(*) Except for OPNEx-MModel, you can find these apps in [Open Exchange](https://openexchange.intersystems.com/)_

OPNEx-MModel could be your own app. It's just a small sample for this project, to demonstrate IRIS features related to Multi-Model. It contains the following classes:

Class|Description
----|----
OPNEx.MModel.Proveedor|%Persistent class with some methods to Register, Update records,...
OPNEx.MModel.Direccion|%SerialObject class
OPNEx.MModel.IOglobals|Utilities to access/record Proveedor data directly from/to the associated global. Massive data generator.
OPNEx.MModel.Util|Implements Limpia() method to kill the extent
OPNEx.MModel.RESTserver|REST Microservices to execute CRUD operations on Proveedor
---

## How to start

### Installation

1) Clone or download this repository
2) IMPORTANT: Copy your own iris.key in ./build/ECP_iris.key. You will need a key that supports ECP. If you don't have it you can get if from Evaluation or Preview sections in WRC (Be aware that ECP it's not supported by IRIS Community Editions).
3) Build the server and client images (you will need access to containers.intersystems.com)

    ```docker-compose build```
4) Deploy the architecture

    ```docker-compose up```
5) Open your postman and import the collection: ``MModelCollection.json``
    - If you don't want to use Postman, these are the URLs for the REST services:

    Desc |Method| URL
    --|--|--
    Search Proveedor by ID|GET|[Sample Link](http://localhost:20080/multimodel/busca/id/20090)
    Register new Proveedor (data in param)|PUT| [Sample Link](http://localhost:20080/multimodel/registro/PROV001/B12345678/Zamora/48001)
    Register new Proveedor (data in body request)|POST|[Sample Link](http://localhost:20080/multimodel/elimina/id/2)
    Delete a Proveedor by ID|DELETE|[Sample Link](http://localhost:20080/multimodel/elimina/id/2)
    Update a Proveedor (data in body request)|PATCH|[Sample Link](http://localhost:20080/multimodel/modifica)
    Generates Records|GET|[Sample Link](http://localhost:20080/multimodel/genera/100)
    Count Proveedores|GET|[Sample Link](http://localhost:20080/multimodel/cuenta)
    Echo Test|GET|[Sample Link](http://localhost:20080/multimodel/echo)

### Check it's working

1) Connect to the Loadbalancer and test that all connections with ECP clients are working (see that _loadbalancer is listening in **port 20080**_)

    ```http
    http://localhost:20080/csp/bin/Systems/Module.cxw
    ```

    - Enter with CSPsystem/SYS
    - Check connections in Test Server Connection option
    - Take a look at Application Access and see the call sequence to ECP client servers
2) Try to log to SMP through the LoadBalancer:

    ```http
    http://localhost:20080/csp/sys/UtilHome.csp
    ```

    You should have currently entered in the SMP of one of the ECP clients servers, likely the first one in the round-robin queue configured in the load-balancer.
3) Check RestForms-UI:

    ```http
    http://localhost:20080/restforms2-ui/index.html
    ```

    You should see the login page to your _Restforms-ui_ app. Login as superuser you'll see all the Forms you have access to. There it's one for Proveedor class (included in this small sample) plus others that _Restforms2_ installs by default as an example.
4) Check Webterminal:
> **[NOV-2025]** Webterminal is not working as it's set up in this project. Once I discover why I'll fix it

    ```http
    http:localhost:52773/terminal/
    ```

   As you can see, I'm **not using** the _load-balancer port 20080_. WebTerminal needs to connect directly to the IRIS instance you want to work with, so you would need to put there the port randomly assigned by docker to your instance.
5) Check the REST services for OPNEx-MModel sample, with Postman or making use of URLs provided above
    - For example, try to generate records of new Proveedores and then get one of them by ID.
    - If you test _Echo Test_ service, you will see that the request is served each time by a different APP server

### To add new APP Servers

If you want to add a new APP Server:

1) Edit ``docker-compose.yml`` file and just Copy & Paste the declaration of one of the client services, for example "client3", and change service, host and container names appropiately.
2) Execute ``docker-compose up -d client4`` from your shell to launch the new ECP APP Client.
3) Go to LoadBalancer/WebGateway portal to add the new AppServer
4) If you want to make this change permanent in your project, you should include that APP Server in ``CSP.ini`` file in _.\\webgatewayconfig\\_ folder (look at the content, the changes to do are pretty straightforward).
### If you're all set...

If you didn't find any issue following the checks above, _Congratulations! Your environment is ready!_

Now, you can use it to demo and to develop your APP or Sample over an ECP architecture, counting with latest versions of ZPM, WebTerminal, Restforms2, Restforms2-ui. And everything "out-of-the-box".

_**Happy Coding!**_


> _To get this project done I've made use of several other contributions from our Community/OpenExchange, so thanks to [Nikita Savchenko](https://openexchange.intersystems.com/user/Nikita%20Savchenko/Ws85ayrkFj6ovsddjFZmVWH8k8) for developing so great app like WebTerminal, [Henry Hamon Pereira](https://openexchange.intersystems.com/user/Henry%20Hamon%20Pereira/wq1IdSjT39T5KZ5LgDh3uwi08sY) who develop Restforms2 framework and [Anton Gnibeda](https://openexchange.intersystems.com/user/Anton%20Gnibeda/UlbMrfpAWTlTMKDRG2GNXUSSHQ) who gave Restforms2 a beautiful face, [Evgeny Shvarov](https://openexchange.intersystems.com/user/Evgeny%20Shvarov/PsVoekohQP54VMJhkXmYMe96mPo) for building ZPM that makes thinks so easy. Specially **BIG THANKS** to [Robert Cemper](https://openexchange.intersystems.com/user/Robert%20Cemper/v2WPTpUS8nGmGLNs612I7IeKRzc) from who I borrowed [IRIS-easy-ECP-workbench](https://openexchange.intersystems.com/package/IRIS-easy-ECP-workbench) as a starting point, and [Pierre-Yves Duquesnoy](https://openexchange.intersystems.com/user/Pierre-Yves%20Duquesnoy/t8U64GJU8G2pS6nd7s124mRFUV0) who helped me contribuiting to this project with a simple LoadBalancer configuration based on our WebGateway_


