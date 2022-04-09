# Create your views here.
import API.stock_details
from rest_framework.decorators import api_view
from rest_framework.response import Response
from .models import User
from django.views.decorators.csrf import csrf_exempt
import Model.auto_train


@csrf_exempt
@api_view(["POST"])
def register(request):
    """
    This function takes in User Details and Registers him/her into the database.
    """
    User.objects.create(
        firstname=request.data["firstname"],
        lastname=request.data["lastname"],
        email=request.data["email"],
        password=request.data["password"],
    )
    return Response({"message": "User Registered Successfully"})


@csrf_exempt
@api_view(["POST"])
def login(request):
    """
    This function takes in User Details and Logs him/her into the database.
    """
    try:
        user = User.objects.get(email=request.data["email"].lower().strip())

        if user.password == request.data["password"]:

            portfolio = user.portfolio.split(";")
            portfolio.remove("")

            arr_main = []
            dict_main = {}
            user.portfolio_value = 0.0
            user.day_projected_value = 0.0
            user.week_projected_value = 0.0
            user.month_projected_value = 0.0
            user.invested_value = 0.0

            for i in range(len(portfolio)):
                (Day, Week, Month, Last, Date) = Model.auto_train.auto_train(
                    portfolio[i].split(",")[0]
                )

                dict_main["Symbol"] = portfolio[i].split(",")[0]
                dict_main["Quantity"] = portfolio[i].split(",")[1]
                dict_main["Invested"] = round(
                    float(portfolio[i].split(",")[2])
                    * float(portfolio[i].split(",")[1]),
                    2,
                )

                dict_main["Company"] = API.stock_details.return_company(
                    portfolio[i].split(",")[0]
                )
                dict_main["Logo"] = API.stock_details.return_logo(
                    portfolio[i].split(",")[0]
                )

                dict_main["LastClose"] = Last
                dict_main["Gain"] = round(
                    (float(dict_main["LastClose"]) - float(portfolio[i].split(",")[2]))
                    * int(portfolio[i].split(",")[1]),
                    2,
                )
                dict_main["Change"] = round(
                    (dict_main["Gain"] / dict_main["Invested"]) * 100, 2
                )

                user.portfolio_value += round(
                    float(Last) * int(portfolio[i].split(",")[1]), 2
                )
                user.day_projected_value += round(
                    float(Day) * int(portfolio[i].split(",")[1]), 2
                )
                user.week_projected_value += round(
                    float(Week) * int(portfolio[i].split(",")[1]), 2
                )
                user.month_projected_value += round(
                    float(Month) * int(portfolio[i].split(",")[1]), 2
                )
                user.invested_value += round(
                    float(portfolio[i].split(",")[2]) * int(portfolio[i].split(",")[1]),
                    2,
                )

                arr_main.append(dict_main)
                dict_main = {}

            change = 0.0
            try:
                change = user.portfolio_value - user.invested_value
                change = change / user.invested_value
                change = change * 100
                change = round(change, 2)
            except ZeroDivisionError:
                change = 0.0

            medium = 0.0
            try:
                medium = user.week_projected_value - user.invested_value
                medium = medium / user.invested_value
                medium = medium * 100
                medium = medium - change
                medium = round(medium, 2)
            except ZeroDivisionError:
                medium = 0.0

            long = 0.0
            try:
                long = user.month_projected_value - user.invested_value
                long = long / user.invested_value
                long = long * 100
                long = long - change
                long = round(long, 2)
            except ZeroDivisionError:
                long = 0.0

            user.save()

            return Response(
                {
                    "message": "Login Successful",
                    "firstname": user.firstname,
                    "lastname": user.lastname,
                    "portfoliovalue": round(user.portfolio_value, 2),
                    "investedvalue": round(user.invested_value, 2),
                    "portfolio": arr_main,
                    "change": change,
                    "medium": medium,
                    "long": long,
                }
            )

        else:
            return Response({"message": "Login Unsuccessful"})
    except User.DoesNotExist:
        return Response({"message": "Login Unsuccessful"})


@csrf_exempt
@api_view(["POST"])
def search(request):
    """
    This function returns the stock details.
    """
    if request.data["purpose"] == "Search":
        stock = request.data["stock"]
        if stock in API.stock_details.return_symbols():
            (Day, Week, Month, Last, Date) = Model.auto_train.auto_train(stock)

            logo = API.stock_details.return_logo(stock)
            company = API.stock_details.return_company(stock)

            return Response(
                {
                    "message": "Found",
                    "logo": logo,
                    "company": company,
                    "day": Day,
                    "week": Week,
                    "month": Month,
                    "last": Last,
                }
            )
        else:
            return Response({"message": "Stock Does Not Exist"})

    else:
        try:
            stock = request.data["stock"]

            if stock in API.stock_details.return_symbols():
                email = request.data["email"]

                user = User.objects.get(email=email)

                (Day, Week, Month, Last, Date) = Model.auto_train.auto_train(stock)

                logo = API.stock_details.return_logo(stock)
                company = API.stock_details.return_company(stock)

                quantity = 0
                buying_price = 0

                for i in user.portfolio.split(";"):
                    if i.split(",")[0] == stock:
                        quantity = i.split(",")[1]
                        buying_price = i.split(",")[2]

                Change = 0
                try:
                    Change = round(
                        ((float(Last) - float(buying_price)) / float(buying_price))
                        * 100,
                        2,
                    )
                except ZeroDivisionError:
                    Change = 0

                DayChange = 0
                try:
                    DayChange = round(
                        ((float(Day) - float(Last)) / float(Last)) * 100,
                        2,
                    )
                except ZeroDivisionError:
                    DayChange = 0

                WeekChange = 0
                try:
                    WeekChange = round(
                        ((float(Week) - float(Last)) / float(Last)) * 100,
                        2,
                    )
                except ZeroDivisionError:
                    WeekChange = 0

                MonthChange = 0
                try:
                    MonthChange = round(
                        ((float(Month) - float(Last)) / float(Last)) * 100,
                        2,
                    )
                except ZeroDivisionError:
                    MonthChange = 0

                return Response(
                    {
                        "message": "Found",
                        "stock": stock,
                        "company": company,
                        "logo": logo,
                        "quantity": quantity,
                        "buyingprice": buying_price,
                        "Change": Change,
                        "Day": Day,
                        "DayChange": DayChange,
                        "Week": Week,
                        "WeekChange": WeekChange,
                        "Month": Month,
                        "MonthChange": MonthChange,
                        "Last": Last,
                        "Date": Date,
                    }
                )

            else:
                return Response({"message": "Stock Does Not Exist"})
        except IndexError:
            return Response({"message": "Stock Does Not Exist"})
