import UIKit
import WebKit

final class WebViewViewController: UIViewController {
    
    @IBOutlet private var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadAuthView()
        webView.navigationDelegate = self
    }
    
    enum WebViewConstants {
        static let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
    }
    
    private func loadAuthView() {
        guard var urlComponents = URLComponents(string: WebViewConstants.unsplashAuthorizeURLString) else {
            print("urlComponents не прошел проверку")
            return
        }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: Constants.accessKey),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "scope", value: Constants.accessScope)
        ]
        
        guard let url = urlComponents.url else {
            print("url не прошел проверку")
            return
        }
        
        let request = URLRequest(url: url)
        webView.load(request)
    }
}
    extension WebViewViewController: WKNavigationDelegate {
        private func webView(
            _webView: WKWebView,
            decidePolicyFor navigationAction: WKNavigationAction,
            decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
        ) {
            if let code = code(from: navigationAction) { // code(:) возвращает кот авторизации, если он получен
                //TODO: process code
                decisionHandler(.cancel) // если код успешно получен - отменяем навигационное действие (ведь мы уже все получили от webView)
            } else {
                decisionHandler(.allow) // если код не получен, разрешаем навигационное действие. Возможно, пользователь просто переходит на новую страницу в рамках процесса авторизации.
            }
        }
        
        private func code(from navigationAction: WKNavigationAction) -> String? {
            if
                let url = navigationAction.request.url,  // получаем из навигационного действия URL
                let urlComponents = URLComponents(string: url.absoluteString), //создаем структуру URLComponents. Теперь мы получаем значения из компонентов из URL (раньше формировали)
                urlComponents.path == "/oauth/authorize/native",  // совпадает ли адрес запроса с адресом получения
                let items = urlComponents.queryItems, // проверяем, есть ли компоненты запроса
                let codeItem = items.first(where: { $0.name == "code" }) // ищем в массиве такой элемент, которого значение "code"
            {
                return codeItem.value //возвращаем его значение, иначе nil
            } else {
                return nil
            }
        }
}
