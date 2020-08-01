import UIKit
import RxCocoa
import RxSwift

final class RepositoryListViewController: UIViewController {

    private let viewStream = RepositoryListViewStream()

    private lazy var dataSource = RepositoryListViewDataSource(viewStream: viewStream)

    private let disposeBag = DisposeBag()

    // MARK: UI

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = dataSource
        tableView.refreshControl = refreshControl
        tableView.register(RepositoryListCell.self)
        tableView.register(UITableViewCell.self) // フォールバック用
        return tableView
    }()

    private let refreshControl = UIRefreshControl()

    init() {
        super.init(nibName: nil, bundle: nil)

        // Bind
        viewStream.output.reloadData
            .bind(to: Binder(tableView) { tableView, _ in
                tableView.reloadData()
            })
            .disposed(by: disposeBag)

        viewStream.output.isRefreshControlRefreshing
            .bind(to: refreshControl.rx.isRefreshing)
            .disposed(by: disposeBag)

        viewStream.output.errorEvent
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: {[weak self] _ in
                self?.showAlert()
            })
            .disposed(by: disposeBag)

        refreshControl.rx.controlEvent(.valueChanged)
            .bind(to: viewStream.input.accept(for: \.refreshControlValueChanged))
            .disposed(by: disposeBag)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Layout
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        viewStream.input.viewWillAppear(())
    }
}

extension RepositoryListViewController {
    private func showAlert() {
        let alert = UIAlertController(title: L10n.error,
                                      message: L10n.repositoryListErrorDescription,
                                      preferredStyle: .alert)

        let action = UIAlertAction(title: L10n.ok,
                                   style: .default)
        { [weak self] _ in
            self?.viewStream.input.reloadEvent(())
        }

        alert.addAction(action)
        self.present(alert, animated: true)
    }
}
